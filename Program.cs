
namespace ArmaWebRequestTests
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.WebHost.ConfigureKestrel(options =>
            {
                options.ConfigureEndpointDefaults(listenOptions =>
                {
                    // Allow HTTP/1.1 (GET request) and HTTP/2 (CONNECT request)
                    listenOptions.Protocols = Microsoft.AspNetCore.Server.Kestrel.Core.HttpProtocols.Http1AndHttp2;
                });
            });


            // Add services to the container.

            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowArmaTest",
                    policy =>
                    {
                        policy.WithOrigins("arma://test").AllowAnyMethod();
                    });

                options.AddPolicy("AllowArmaTest_PUT",
                    policy =>
                    {
                        policy.WithOrigins("arma://test").WithMethods("PUT");
                    });

                options.AddPolicy("AllowArmaNull",
                    policy =>
                    {
                        policy.WithOrigins("arma://null").AllowAnyMethod();
                    });

                options.AddPolicy("AllowWildcard",
                    policy =>
                    {
                        policy.AllowAnyOrigin().AllowAnyMethod();
                    });

                options.AddPolicy("AllowWildcard_PUT",
                    policy =>
                    {
                        policy.AllowAnyOrigin().WithMethods("PUT");
                    });

                options.AddPolicy("AllowNone",
                    policy =>
                    {
                        policy.WithOrigins("https://example.org").AllowAnyMethod();
                    });
            });


            builder.Services.AddHttpLogging(logging =>
            {
                // Bestimmt, welche Daten protokolliert werden (Headers, RequestPath, Method, etc.)
                logging.LoggingFields = Microsoft.AspNetCore.HttpLogging.HttpLoggingFields.All;

                // Optional: Bestimmte Header explizit erlauben, falls sie sonst maskiert werden
                logging.RequestHeaders.Add("Upgrade");
                logging.RequestHeaders.Add("Connection");
                logging.RequestHeaders.Add("Sec-WebSocket-Key");
                logging.RequestHeaders.Add("Sec-WebSocket-Version");
                logging.RequestHeaders.Add("Access-Control-Request-Headers");
                logging.RequestHeaders.Add("Access-Control-Request-Method");
            });


            builder.Services.AddControllers();
            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            builder.Services.AddOpenApi();

            builder.Services.AddHostedService<mDNSHostedService>();

            var app = builder.Build();

            app.UseHttpLogging();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.MapOpenApi();
            }

            app.UseWebSockets(new WebSocketOptions
            {
                // Configures the internal buffer size used to parse and receive frames (Default is 4KB)
                //ReceiveBufferSize = 70 * 1024
            });

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
