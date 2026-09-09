using Makaretu.Dns;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Net.NetworkInformation;

namespace ArmaWebRequestTests
{
    public class mDNSHostedService : IHostedService
    {
        private readonly ILogger<mDNSHostedService> _logger;

        private MulticastService mdns = new MulticastService();

        public mDNSHostedService(ILogger<mDNSHostedService> logger)
        {
            _logger = logger;
        }


        public async Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Initializing Haukcode mDNS Advertiser...");

            // https://github.com/cosinekitty/zeroconfig this instead?

            List<IPAddress> addresses = new();

            //foreach (var ni in NetworkInterface.GetAllNetworkInterfaces())
            //{
            //    if (ni.OperationalStatus == OperationalStatus.Up &&
            //        ni.NetworkInterfaceType != NetworkInterfaceType.Loopback)
            //    {
            //        var props = ni.GetIPProperties();
            //        foreach (var addr in props.UnicastAddresses)
            //        {
            //            if (addr.Address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
            //            {
            //                addresses.Add(addr.Address);
            //            }
            //        }
            //    }
            //}


            addresses.Add(IPAddress.Loopback);

            var serviceProfile = new ServiceProfile("ASPNetSample", "_arma3web._tcp", 7082, addresses);

            serviceProfile.HostName = new DomainName("ASPNetSample_a3web.local");

            // 3. Inject explicit Key/Value pairs into the TXT record map if needed
            serviceProfile.Resources.Add(new TXTRecord
            {
                Name = serviceProfile.FullyQualifiedName,
                Strings = { "version=1.0", "status=running", "path=/api/v1" }
            });


            // 6. Register the completed profile and spin up the engine
            var serviceDiscovery = new ServiceDiscovery(mdns);
            serviceDiscovery.Advertise(serviceProfile);
 
            mdns.Start();
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            if (mdns != null)
            {
                _logger.LogInformation("Stopping mDNS advertiser (sending goodbye packets)...");

                // This stops the broadcast and tears down sockets cleanly
                mdns.Dispose();
            }

            return Task.CompletedTask;
        }

    }
}
