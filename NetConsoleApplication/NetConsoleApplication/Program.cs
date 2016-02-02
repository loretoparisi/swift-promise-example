using System;
using NetClassLibrary;
using System.Threading.Tasks;

namespace NetConsoleApplication
{
	class MainClass
	{
		private static Task TestAsync()
		{
			return Task.Run(() => TaskToDo());
		}

		private async static void TaskToDo()
		{
			await Task.Delay(10);

			SharedClassTest sampleAPI = new SharedClassTest ();
			String apiURL = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";


			sampleAPI.setup();

			sampleAPI.getJsonObject__success__error(apiURL, (result) => {
				Console.WriteLine("RESPONSE", result);
			},
			(e) => {
				Console.WriteLine("EXCEPTION", e.Message);
			});

			Console.WriteLine();
		}

		private static async void TestLibrary()
		{
			await TestAsync();
		}

		public static void Main (string[] args)
		{
			TestLibrary();
			Console.Read();
		}
	}
}
