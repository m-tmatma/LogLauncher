using System;

namespace test
{
    class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine("Hello World");
            if( args.Length > 0)
            {
                try
                {
                    int number = Int32.Parse(args[0]);
                    Console.WriteLine("return {0}", number);
                    return number;
                }
                catch (Exception)
                {
                    Console.WriteLine("return {0}", 1);
                    return 1;
                }
            }
            Console.WriteLine("return {0}", 0);
            return 0;
        }
    }
}
