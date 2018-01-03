using System;
using System.Collections.Generic;
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
            TimeStampTZ,    // append timestamp and timezone to the head of line
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

        public class UnknownOptionException : Exception
        {
            public UnknownOptionException()
            {
            }

            public UnknownOptionException(string message)
                : base(message)
            {
            }
        }

        public class LogFileNotFoundException : Exception
        {
            public LogFileNotFoundException()
            {
            }

            public LogFileNotFoundException(string message)
                : base(message)
            {
            }
        }

        public class SeparatorNotFoundException : Exception
        {
            public SeparatorNotFoundException()
            {
            }

            public SeparatorNotFoundException(string message)
                : base(message)
            {
            }
        }

        public class ArgumentNotFoundException : Exception
        {
            public ArgumentNotFoundException()
            {
            }

            public ArgumentNotFoundException(string message)
                : base(message)
            {
            }
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
                case TimeStamp.TimeStampTZ:
                    return AddTimeStampTZ(line);
            }
            return line;
        }

        /// <summary>
        /// parse commandline argument
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static Option ParseCommandLine(string[] args)
        {
            var mainArgs = new List<string>();
            var programArgs = new List<string>();

            bool foundSeparater = false;
            foreach (string arg in args)
            {
                if (!foundSeparater)
                {
                    if (string.Compare(arg, "--") == 0)
                    {
                        foundSeparater = true;
                        continue;
                    }
                    mainArgs.Add(arg);
                }
                else
                {
                    programArgs.Add(arg);
                }
            }
            if (!foundSeparater)
            {
                throw new SeparatorNotFoundException();
            }
            if (programArgs.Count == 0)
            {
                throw new ArgumentNotFoundException();
            }

            var option = new Option();
            option.Timestamp = LogLauncher.TimeStamp.None;
            option.FileName = null;
            option.IsAppend = false;
            option.Args = programArgs.ToArray();

            foreach (string arg in mainArgs)
            {
                if (arg.StartsWith("-"))
                {
                    if (string.Compare(arg, "-a") == 0)
                    {
                        option.IsAppend = true;
                    }
                    else if (string.Compare(arg, "-t") == 0)
                    {
                        option.Timestamp = LogLauncher.TimeStamp.TimeStamp;
                    }
                    else if (string.Compare(arg, "-tz") == 0)
                    {
                        option.Timestamp = LogLauncher.TimeStamp.TimeStampTZ;
                    }
                    else
                    {
                        throw new UnknownOptionException(arg);
                    }
                }
                else
                {
                    option.FileName = arg;
                }
            }

            if (option.FileName == null)
            {
                throw new LogFileNotFoundException();
            }
            return option;
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
