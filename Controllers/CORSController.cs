using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

namespace ArmaWebRequestTests.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CORSTestController : ControllerBase
    {
        private static readonly string[] Summaries =
        [
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        ];

        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }


        [EnableCors("AllowArmaTest")]
        [HttpGet(Name = "ArmaCors")]
        [Route("ArmaCors")]
        public IEnumerable<WeatherForecast> GetArmaCors()
        {
            return Get();
        }


        [EnableCors("AllowArmaNull")]
        [HttpGet(Name = "ArmaNull")]
        [Route("ArmaNull")]
        public IEnumerable<WeatherForecast> GetArmaNull()
        {
            return Get();
        }


        [EnableCors("AllowWildcard")]
        [HttpGet(Name = "Wildcard")]
        [Route("Wildcard")]
        public IEnumerable<WeatherForecast> GetWildcard()
        {
            return Get();
        }


        [EnableCors("AllowNone")]
        [HttpGet(Name = "None")]
        [Route("None")]
        public IEnumerable<WeatherForecast> GetNone()
        {
            return Get();
        }

        [DisableCors()]
        [HttpGet(Name = "NoCORS")]
        [Route("NoCORS")]
        public IEnumerable<WeatherForecast> GetNoCORS()
        {
            return Get();
        }


        [EnableCors("AllowWildcard_PUT")]
        [HttpGet(Name = "ArmaPUT")]
        [Route("ArmaPUT")]
        public IEnumerable<WeatherForecast> GetArmaPUT()
        {
            return Get();
        }

    }
}
