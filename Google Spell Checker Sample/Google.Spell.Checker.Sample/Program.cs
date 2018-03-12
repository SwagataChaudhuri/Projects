using System;
using System.IO;
using System.Net;
using System.Xml.Linq;

namespace Google.Spell.Checker.Sample
{
    class Program
    {
        static void Main(string[] args)
        {
            Initialize:
            try
            {               
                string returnValue = string.Empty;
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Google Autocorrect API Reference");
                Console.WriteLine("********************************\n");
                Console.Write("Enter term for suggestion : ");
                string inputText = Console.ReadLine();
                Console.WriteLine();
                string uri = string.Format("http://www.google.com/complete/search?output=toolbar&q={0}", inputText);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(uri);
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                using (StreamReader sr = new StreamReader(response.GetResponseStream()))
                {
                    returnValue = sr.ReadToEnd();
                }
                XDocument doc = XDocument.Parse(returnValue);
                XAttribute attr = doc.Root.Element("CompleteSuggestion").Element("suggestion").Attribute("data");
                string correctedWord = attr.Value;
                Console.WriteLine("Suggested Term : {0}\n", correctedWord);
            }
            catch (Exception)
            {                
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Some error occurred!!\n");
                System.Threading.Thread.Sleep(2500);
                Console.Clear();
                goto Initialize;
            }
        }
    }
}
