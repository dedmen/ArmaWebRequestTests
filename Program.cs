
namespace ArmaWebRequestTests
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

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


            builder.Services.AddControllers();
            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            builder.Services.AddOpenApi();

            builder.Services.AddHostedService<mDNSHostedService>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.MapOpenApi();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
