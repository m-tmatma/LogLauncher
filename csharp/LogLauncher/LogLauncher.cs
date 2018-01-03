using System;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace LogLauncher
{
    public class LogLauncher
    {
        /// <summary>
        /// timestamp option
        /// </summary>
        public enum TimeStamp
        {
            None,           // use original text
            TimeStamp,      // append timestamp to the head of line
            TimeStameTZ,    // append timestamp and timezone to the head of line
        }

        /// <summary>
        /// Option class
        /// </summary>
        public class Option
        {
            /// <summary>
            /// Output log filename
            /// </summary>
            public string FileName { get; set; }

            /// <summary>
            /// whether append log to the end of file
            /// </summary>
            public bool IsAppend { get; set; }

            /// <summary>
            /// timestamp option
            /// </summary>
            public TimeStamp Timestamp { get; set; }

            /// <summary>
            /// Argument for a program be launched
            /// </summary>
            public string[] Args { get; set; }
        }

        /// <summary>
        /// append timestamp to data
        /// </summary>
        /// <param name="line"></param>
        /// <returns></returns>
        private static string AddTimeStamp(string line)
        {
            var dt = DateTime.Now;
            var ts = dt.ToString("yyyy/MM/dd HH:mm:ss.fff");

            return "[" + ts + "] " + line;
        }

        /// <summary>
        /// append timestamp and timezone to data
        /// </summary>
        /// <param name="line"></param>
        /// <returns></returns>
        private static string AddTimeStampTZ(string line)
        {
            var tz = System.TimeZoneInfo.Local;
            var dt = DateTime.Now;
            var ts = dt.ToString("yyyy/MM/dd HH:mm:ss.fff");

            return string.Format("[{0} {1}] {2}", ts, tz, line);
        }

        /// <summary>
        /// process line data
        /// </summary>
        /// <param name="timestamp"></param>
        /// <param name="line"></param>
        /// <returns></returns>
        static string ProcessLine(TimeStamp timestamp, string line)
        {
            switch (timestamp)
            {
                case TimeStamp.None:
                    return line;
                case TimeStamp.TimeStamp:
                    return AddTimeStamp(line);
                case TimeStamp.TimeStameTZ:
                    return AddTimeStampTZ(line);
            }
            return line;
        }

        /// <summary>
        /// launch program and log to the output
        /// </summary>
        /// <param name="option"></param>
        /// <returns></returns>
        public static int Launch(Option option)
        {
            string argument = string.Empty;
            if (option.Args.Length < 1)
            {
                return 1;
            }
            else if (option.Args.Length > 1)
            {
                var new_length = option.Args.Length - 1;
                string[] arguments = new string[new_length];
                Array.Copy(option.Args, 1, arguments, 0, new_length);
                argument = string.Join(" ", arguments);
            }

            var process = new Process();
            process.StartInfo.FileName = option.Args[0];
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.StartInfo.RedirectStandardError = true;
            process.StartInfo.RedirectStandardInput = false;

            process.StartInfo.CreateNoWindow = false;
            process.StartInfo.Arguments = argument;

            try
            {
                var fileMode = option.IsAppend ? FileMode.Append : FileMode.Create;
                var encoding = Encoding.Default;

                using (var fs = File.Open(option.FileName, fileMode, FileAccess.Write, FileShare.Read))
                {
                    using (var streamWriter = new StreamWriter(fs))
                    {
                        process.OutputDataReceived += new DataReceivedEventHandler(delegate (object obj, DataReceivedEventArgs e)
                        {
                            var data = ProcessLine(option.Timestamp, e.Data);
                            streamWriter.WriteLine(data);
                            Console.WriteLine(data);
                        });
                        process.ErrorDataReceived += new DataReceivedEventHandler(delegate (object obj, DataReceivedEventArgs e)
                        {
                            var data = ProcessLine(option.Timestamp, e.Data);
                            streamWriter.WriteLine(data);
                            Console.WriteLine(data);
                        });

                        process.Start();

                        process.BeginOutputReadLine();
                        process.BeginErrorReadLine();
                        process.WaitForExit();
                    }
                }
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
