using System;
using System.Diagnostics;

namespace LogLauncher
{
    class Program
    {
        static int Main(string[] args)
        {
            var option = new LogLauncher.Option();
            option.Timestamp = LogLauncher.TimeStamp.None;
            option.FileName = "out.txt";
            option.IsAppend = true;
            option.Args = args;
            var ret = LogLauncher.Launch(option, args);
            return ret;
        }
    }
}
