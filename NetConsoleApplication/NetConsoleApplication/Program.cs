using System;
using NetClassLibrary;

namespace NetConsoleApplication
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			Console.WriteLine ("Hello World!");


			SharedClassTest sampleAPI = new SharedClassTest ();
			String apiURL = "https://api.spotify.com/v1/search?q=tania%20bowra&type=artist";


			sampleAPI.setup();

			sampleAPI.getJsonObject__success__error(apiURL, (s) => {
				Console.WriteLine("TEST", s);
				},
				(e) => {
					Console.WriteLine("TEST", e.Message);
				});
			Console.ReadLine ();
		}
	}
}
