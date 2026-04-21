param([string]$Message = "알림")

# 1) Primary monitor: BurntToast
Import-Module BurntToast
New-BurntToastNotification -Text "Claude Code", $Message

# 2) Secondary monitor: WPF custom toast
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$secondary = [System.Windows.Forms.Screen]::AllScreens | Where-Object { -not $_.Primary } | Select-Object -First 1
if (-not $secondary) { exit 0 }

$b = $secondary.Bounds
$w = 340; $h = 80; $m = 16
$posX = $b.Left + $b.Width - $w - $m
$posY = $b.Top + $b.Height - $h - $m - 48

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False"
        Left="$posX" Top="$posY" Width="$w" Height="$h">
    <Border CornerRadius="12" Background="#5B6EE1" BorderBrush="#4855B5" BorderThickness="1">
        <Border.Effect>
            <DropShadowEffect BlurRadius="15" ShadowDepth="2" Opacity="0.5" Color="Black"/>
        </Border.Effect>
        <Grid Margin="16,12">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
            </Grid.RowDefinitions>
            <TextBlock Grid.Row="0" Text="&#x1F916; Claude Code" FontSize="13" FontWeight="SemiBold" Foreground="#FFFFFF" Margin="0,0,0,4"/>
            <TextBlock Grid.Row="1" Text="$Message" FontSize="12" Foreground="#E8EAFF" TextWrapping="Wrap"/>
        </Grid>
    </Border>
</Window>
"@

$window = [System.Windows.Markup.XamlReader]::Load([System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml)))
$window.Add_Closed({ [System.Windows.Threading.Dispatcher]::CurrentDispatcher.InvokeShutdown() })
$window.Add_MouseLeftButtonDown({ $window.Close() })
$window.Opacity = 0
$window.Show()
$window.BeginAnimation([System.Windows.UIElement]::OpacityProperty,
    [System.Windows.Media.Animation.DoubleAnimation]::new(0, 1, [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300))))

$timer = [System.Windows.Threading.DispatcherTimer]::new()
$timer.Interval = [TimeSpan]::FromSeconds(4)
$timer.Add_Tick({
    $fade = [System.Windows.Media.Animation.DoubleAnimation]::new(1, 0, [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(500)))
    $fade.Add_Completed({ $window.Close() })
    $window.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $fade)
    $timer.Stop()
})
$timer.Start()

[System.Windows.Threading.Dispatcher]::Run()
