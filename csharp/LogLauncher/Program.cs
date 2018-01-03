using System;
using System.Diagnostics;

namespace LogLauncher
{
    class Program
    {
        static int Main(string[] args)
        {
            var ret = LogLauncher.Launch(args);
            return ret;
        }
    }
}
