using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;

namespace ArmaWebRequestTests.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [EnableCors("AllowWildcard")]
    public class TestCaseController : ControllerBase
    {

        [HttpGet]
        [Route("5SecDelay")]
        public async Task<IActionResult> Get5SecDelay()
        {
            var start = DateTime.UtcNow;

            await Task.Delay(5000);

            var randomUpdate = new { Message = $"Started at {start}, reply at {DateTime.UtcNow}" };
            return Ok(randomUpdate);
        }

        [HttpGet]
        [Route("30SecDelay")]
        public async Task<IActionResult> Get30SecDelay()
        {
            var start = DateTime.UtcNow;

            await Task.Delay(30000);

            var randomUpdate = new { Message = $"Started at {start}, reply at {DateTime.UtcNow}" };
            return Ok(randomUpdate);
        }

        [HttpGet]
        [Route("40SecDelay")]
        public async Task<IActionResult> Get40SecDelay()
        {
            var start = DateTime.UtcNow;

            await Task.Delay(40000);

            var randomUpdate = new { Message = $"Started at {start}, reply at {DateTime.UtcNow}" };
            return Ok(randomUpdate);
        }


        [HttpGet]
        [Route("404")]
        public async Task<IActionResult> Get404()
        {
            return NotFound();
        }

    }
}
