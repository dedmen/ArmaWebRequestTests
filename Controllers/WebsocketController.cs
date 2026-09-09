using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Concurrent;
using System.Net.WebSockets;
using System.Text;

namespace ArmaWebRequestTests.Controllers
{
    [ApiController]
    [Route("websocket")]
    public class WebsocketController : ControllerBase
    {

        #region Echo
        [EnableCors("AllowWildcard")]
        [AcceptVerbs("GET", "CONNECT")] // HTTP/1.1 and HTTP/2
        [Route("echo")]
        public async Task GetEcho()
        {
            if (HttpContext.WebSockets.IsWebSocketRequest)
            {
                // Upgrade the HTTP connection to a WebSocket connection
                using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();

                // Handle the continuous communication loop
                await EchoLoop(webSocket);
            }
            else
            {
                // Return 400 Bad Request if a regular HTTP client calls this endpoint
                HttpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            }
        }

        async Task EchoLoop(System.Net.WebSockets.WebSocket webSocket)
        {
            var buffer = new byte[1024 * 4];

            // Schleife läuft, bis der Client die Verbindung schließt
            while (webSocket.State == System.Net.WebSockets.WebSocketState.Open)
            {
                var result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

                if (result.MessageType == System.Net.WebSockets.WebSocketMessageType.Close)
                {
                    await webSocket.CloseAsync(result.CloseStatus!.Value, result.CloseStatusDescription, CancellationToken.None);
                }
                else
                {
                    // Echo: Empfangene Nachricht direkt an den Client zurücksenden
                    await webSocket.SendAsync(
                        new ArraySegment<byte>(buffer, 0, result.Count),
                        result.MessageType,
                        result.EndOfMessage,
                        CancellationToken.None);
                }
            }
        }

        #endregion Echo

        #region Relay
        [EnableCors("AllowWildcard")]
        [AcceptVerbs("GET", "CONNECT")]
        [Route("relay")]
        public async Task GetRelay()
        {
            if (HttpContext.WebSockets.IsWebSocketRequest)
            {
                using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();

                // Generiere eine eindeutige ID für diesen Client
                string connectionId = Guid.NewGuid().ToString();
                WebSocketConnectionManager.InstanceRelay.AddSocket(connectionId, webSocket);

                try
                {
                    await RelayLoop(connectionId, webSocket);
                }
                finally
                {
                    // Sicherstellen, dass die Verbindung bei Verbindungsabbruch entfernt wird
                    await WebSocketConnectionManager.InstanceRelay.RemoveSocketAsync(connectionId);
                }
            }
            else
            {
                HttpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            }
        }

        private async Task RelayLoop(string connectionId, WebSocket webSocket)
        {
            var buffer = new byte[1024 * 4];
            string incomingMessage = "";

            while (webSocket.State == WebSocketState.Open)
            {
                var result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);

                if (result.MessageType == WebSocketMessageType.Close)
                {
                    break;
                }
                else if (result.MessageType == WebSocketMessageType.Text)
                {

                    // There are two options to handle large messages
                    // Collect the whole message, and pass along the whole message
                    // Pass along all the chunks, will be sent on as partial frames, that the receiver needs to reassemble.

                    if (true)
                    {
                        incomingMessage = incomingMessage + Encoding.UTF8.GetString(buffer, 0, result.Count);

                        // A message might not fit into our buffer, if that is the case, continue looping and collecting all parts, until we are complete
                        if (result.EndOfMessage)
                        {
                            await WebSocketConnectionManager.InstanceRelay.BroadcastMessageAsync(incomingMessage, senderId: connectionId, true);

                            incomingMessage = "";
                        }
                    }
                    else
                    {
                        incomingMessage = Encoding.UTF8.GetString(buffer, 0, result.Count);
                        await WebSocketConnectionManager.InstanceRelay.BroadcastMessageAsync(incomingMessage, senderId: connectionId, result.EndOfMessage);
                        incomingMessage = "";
                    }
                }
            }
        }

        public class WebSocketConnectionManager
        {
            public static WebSocketConnectionManager InstanceRelay = new WebSocketConnectionManager();

            // Speichert alle aktiven Verbindungen mit einer eindeutigen ID
            private readonly ConcurrentDictionary<string, WebSocket> _sockets = new();

            public void AddSocket(string id, WebSocket socket)
            {
                _sockets.TryAdd(id, socket);
            }

            public async Task RemoveSocketAsync(string id)
            {
                if (_sockets.TryRemove(id, out var socket))
                {
                    if (socket.State == WebSocketState.Open)
                    {
                        await socket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Verbindung geschlossen", CancellationToken.None);
                    }
                }
            }

            // Sendet die Nachricht an ALLE Clients (außer optional dem Sender selbst)
            public async Task BroadcastMessageAsync(string message, string senderId, bool endOfMessage = true)
            {
                var buffer = Encoding.UTF8.GetBytes(message);
                var segment = new ArraySegment<byte>(buffer);

                var tasks = _sockets
                    .Where(pair => pair.Key != senderId && pair.Value.State == WebSocketState.Open)
                    .Select(pair => pair.Value.SendAsync(segment, WebSocketMessageType.Text, endOfMessage, CancellationToken.None));

                // Alle Sendevorgänge parallel ausführen
                await Task.WhenAll(tasks);
            }
        }










        #endregion Relay






    }
}
