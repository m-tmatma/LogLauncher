using System;
using System.Diagnostics;

namespace LogLauncher
{
    class Program
    {
        static void OutputDataReceived(
            object sender,
            DataReceivedEventArgs e)
        {
            Console.WriteLine(e.Data);
        }
        static void ErrorDataReceived(
            object sender,
            DataReceivedEventArgs e)
        {
            Console.WriteLine(e.Data);
        }

        static int Main(string[] args)
        {
            string argument = string.Empty;
            if (args.Length < 1)
            {
                Console.WriteLine("usage ");
                return 1;
            }
            else if (args.Length > 1)
            {
                var new_length = args.Length - 1;
                string[] arguments = new string[new_length];
                Array.Copy(args, 1, arguments, 0, new_length);
                argument = string.Join(" ", arguments);
            }

            var process = new Process();
            process.StartInfo.FileName = args[0];
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.RedirectStandardError = true;
            process.StartInfo.RedirectStandardInput = false;

            process.StartInfo.CreateNoWindow = false;
            process.StartInfo.Arguments = argument;
            process.OutputDataReceived += OutputDataReceived;
            process.ErrorDataReceived += ErrorDataReceived;

            try
            {
                process.Start();
           
                process.BeginOutputReadLine();
                process.BeginErrorReadLine();
                process.WaitForExit();

                return process.ExitCode;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return 1;
            }
        }
    }
}
