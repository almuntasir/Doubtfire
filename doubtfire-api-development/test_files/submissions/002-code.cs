using System;

namespace HelloWorld
{
	class MainClass
	{
		public static void Main (string[] args)
		{
			
			Message myMessage;
			myMessage = new Message ("Hello World - from Message Object");
			myMessage.Print ();

			Message[] Messages = new Message[4];
			Messages [0] = new Message ("Welcome back oh great creator!");
			Messages [1] = new Message ("何やってんの、このバカアニキ！？");
			Messages [2] = new Message ("What am I doing with my life?");
			Messages [3] = new Message ("I am Bagu!");


			Console.WriteLine ("Enter name: ");
			string name = Console.ReadLine ();

			if (name == "Josh") {
				Messages [0].Print ();
			} else if (name == "Junichi") {
				Messages [1].Print ();
			} else if (name == "Kazuki") {
				Messages [2].Print ();
			} else {
				Messages [3].Print ();
			}
				
			Console.ReadLine ();
		}
	}
}
