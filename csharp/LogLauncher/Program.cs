using System;
using System.Diagnostics;

namespace LogLauncher
{
    class Program
    {
        static int Main(string[] args)
        {
            try
            {
                var option = LogLauncher.ParseCommandLine(args);
                var ret = LogLauncher.Launch(option);
                return ret;
            }
            catch (LogLauncher.UnknownOptionException e)
            {
                Console.WriteLine("unknown option {0} found", e.Message);
                return 1;
            }
            catch (LogLauncher.LogFileNotFoundException)
            {
                Console.WriteLine("log filename not found");
                return 1;
            }
            catch (LogLauncher.SeparatorNotFoundException)
            {
                Console.WriteLine("separator '--' not found");
                return 1;
            }
            catch (LogLauncher.ArgumentNotFoundException)
            {
                Console.WriteLine("arguement not found");
                return 1;
            }
        }
    }
}
