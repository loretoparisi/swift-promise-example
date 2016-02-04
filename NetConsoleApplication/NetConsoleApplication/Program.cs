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
			sampleAPI.setup();

			String apiURL = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";

			Action<String> success = (String value) => {
				Console.WriteLine("RESPONSE");
				Console.WriteLine(value);
			};

			Action<Exception> error = (Exception exception) => {
				Console.WriteLine("Error");
				Console.WriteLine(exception);
			};
			sampleAPI.getJsonString__success__error(apiURL, success, error);

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
