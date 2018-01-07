using System;

namespace LogLauncher
{
    class Program
    {
        static void Usage()
        {
            var progname = System.AppDomain.CurrentDomain.FriendlyName;
            Console.Error.WriteLine("usage: {0} [-a] [-t] [-tz] filename -- program.exe [parameters to program.exe]",
                progname);
            Console.Error.WriteLine("-a: append logs to the end of file.");
            Console.Error.WriteLine("-t: append timestamps to the heads of each lines.");
            Console.Error.WriteLine("-tz: append timestamps and timezones to the heads of each lines.");
            Console.Error.WriteLine("filename: log filename");
            Console.Error.WriteLine("");

            Console.Error.WriteLine("example:");
            Console.Error.WriteLine("{0}    -t  log.txt -- cmd.exe /c dir", progname);
            Console.Error.WriteLine("{0} -a -t  log.txt -- cmd.exe /c dir", progname);
            Console.Error.WriteLine("{0}    -tz log.txt -- cmd.exe /c dir", progname);
            Console.Error.WriteLine("{0} -a -tz log.txt -- cmd.exe /c dir", progname);
        }

        static int Main(string[] args)
        {
            if (args.Length == 0)
            {
                Usage();
                return 0;
            }
            try
            {
                var option = LogLauncher.ParseCommandLine(args);
                var ret = LogLauncher.Launch(option);
                return ret;
            }
            catch (LogLauncher.UnknownOptionException e)
            {
                Console.Error.WriteLine("unknown option {0} found", e.Message);
                Usage();
                return 1;
            }
            catch (LogLauncher.LogFileNotFoundException)
            {
                Console.Error.WriteLine("log filename not found");
                Usage();
                return 1;
            }
            catch (LogLauncher.SeparatorNotFoundException)
            {
                Console.Error.WriteLine("separator '--' not found");
                Usage();
                return 1;
            }
            catch (LogLauncher.ArgumentNotFoundException)
            {
                Console.Error.WriteLine("arguement not found");
                Usage();
                return 1;
            }
        }
    }
}
