---
title: "[.NET] WebView2 單一檔案部屬"
date: 2023-06-15T11:03:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[.NET] WebView2 單檔部屬"
    identifier: dotnet-webview2-single-file
    parent: dotnet
    weight: 1000
---
## AssemblyHelper.cs
```c#
public class AssemblyHelper
{
  public string Name
  {
    get
    {
      return this.assembly.GetName().Name;
    }
  }
  public string AppDataPath { get; set; }
  private Assembly assembly;
  public AssemblyHelper() {

    assembly = Assembly.GetCallingAssembly();
    AppDataPath = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
    AppDataPath = Path.Combine(AppDataPath, Name);
  }
  /// <summary>
  /// Extract embeded dll to target path
  /// </summary>
  /// <param name="resourceName">Dll embed path</param>
  /// <param name="targetPath">Dll extract distination</param>
  public void ExtractEmbeddedDLL(string resourceName, string targetPath)
  {
    var targetDir = Path.GetDirectoryName(targetPath);
    if (!string.IsNullOrEmpty(targetDir) && !Directory.Exists(targetDir)) Directory.CreateDirectory(targetDir);

    using (Stream resourceStream = assembly.GetManifestResourceStream(resourceName))
    {
      using (FileStream fileStream = new FileStream(targetPath, FileMode.Create))
      {
        resourceStream.CopyTo(fileStream);
      }
    }
  }
  /// <summary>
  /// 設置解析組件路徑的事件處理常式
  /// </summary>
  public void EnableEmbededManifestDll() => AppDomain.CurrentDomain.AssemblyResolve += OnResolveAssembly;
  
  /// <summary>
  /// Assembly 解析行為
  /// </summary>
  /// <param name="sender"></param>
  /// <param name="args"></param>
  /// <returns></returns>
  public static Assembly OnResolveAssembly(object sender, ResolveEventArgs args)
  {

    Assembly executName = Assembly.GetExecutingAssembly();

    string project = Assembly.GetEntryAssembly().GetName().Name;
    string manifestItem = $"{project}.{new AssemblyName(args.Name).Name}.dll";
    using (Stream stream = executName.GetManifestResourceStream(manifestItem))
    {
      if (stream == null) return null;

      byte[] assemblyRawBytes = new byte[stream.Length];
      stream.Read(assemblyRawBytes, 0, assemblyRawBytes.Length);
      return Assembly.Load(assemblyRawBytes);
    }
  }
}
```
## Program.cs
```C#
  internal static class Program
  {
    [STAThread]
    static void Main()
    {
      try
      {

        var asm = new AssemblyHelper();
        asm.EnableEmbededManifestDll();

        // 抽出 webview2 runtimes (WebView2Loader.dll)， 依需要抽出 x64, x86, arm 版本
        var loaderDllEmbededPath = $"{asm.Name}.runtimes.win_x64.native.WebView2Loader.dll";
        var loaderDllFolderPath = Path.Combine(asm.AppDataPath, "runtimes\\win-x64\\native\\WebView2Loader.dll");
        asm.ExtractEmbeddedDLL(loaderDllEmbededPath, loaderDllFolderPath);

        // 將需注入 DLL 的邏輯抽離 Main 才能跑
        run(loaderDllFolderPath);
      } catch (Exception ex) {
        MessageBox.Show(ex.Message);
      }
    }
    private static void run(string loaderDllFolderPath)
    {
      // Set LoaderDllFolderPath for WebView2 
      CoreWebView2Environment.SetLoaderDllFolderPath(loaderDllFolderPath);

      Application.EnableVisualStyles();
      Application.SetCompatibleTextRenderingDefault(false);
      Application.Run(new Form1());
    }
  }
```