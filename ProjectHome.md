**Tunerie** is a Ruby on Rails web application that provides the ability to control **SiliconDust HDHomeRun** networked TV tuners with a web browser.

Once configured, you can use Tunerie to select channels on the device tuners and stream them to a listening client such as VLC to display the live high-definition TV programs from your cable or antenna feed.

<table><tr><td><a href='https://picasaweb.google.com/lh/photo/-9T5MzBjcB9NpFued4rGM71TsUftXeMKnGJzVk2kuZI?feat=embedwebsite'><img src='https://lh6.googleusercontent.com/-3HQOCbVQgj0/Td6yPNib5QI/AAAAAAAAACE/iZdV6iidz8w/s144/Screen%252520shot%2525202011-05-26%252520at%2525203.51.04%252520PM.png' /></a></td><td><a href='https://picasaweb.google.com/lh/photo/QUvjRPyNqB2cK2AyvqeSqr1TsUftXeMKnGJzVk2kuZI?feat=embedwebsite'><img src='https://lh5.googleusercontent.com/-zVmc6L7i57c/Td6yRC0GG2I/AAAAAAAAACI/WjbAlyHKMwo/s144/Screen%252520shot%2525202011-05-26%252520at%2525203.51.19%252520PM.png' height='102' width='144' /></a></td></tr><tr><td>From <a href='https://picasaweb.google.com/lh/sredir?uname=103412476973675737495&target=ALBUM&id=5611117999347171665&feat=embedwebsite'>Tunerie</a></td></tr></table>

For more information, visit:

  * SiliconDust:    http://www.silicondust.com/
  * VideoLAN:       http://www.videolan.org/
  * Ruby:           http://www.ruby-lang.org/
  * Ruby on Rails:  http://rubyonrails.org/

# Prerequisites #

You need to have the following to run and access Tunerie:

  * Web browser
  * Ruby 1.8.7 or better
  * Rails 3.0.6 or better
  * SiliconDust HDHomeRun hardware
  * SiliconDust HDHomeRun software

There are several ways to get a Ruby on Rails environment to run Tunerie:

  * RailsInstaller on Windows (http://railsinstaller.org/)
  * BitNami RubyStack on Windows, OS X, or Linux (http://bitnami.org/stack/rubystack)
  * Roll your own UNIX / BSD / Linux platform Ruby on Rails stack

Make sure that you install the HDHomeRun software and make it
accessible to Tunerie.  On Windows, this means editing the
PATH system variable to include the location of the
hdhomerun\_config.exe.  On UNIX / BSD / Linux, this executable
is usually installed at a location in the existing PATH.