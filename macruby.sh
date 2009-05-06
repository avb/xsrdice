#!/usr/local/bin/macruby

hg_output = `hg id -i`
version = "0.3.2"
list = NSMutableDictionary.dictionaryWithContentsOfFile("Info.plist")
list["CFBundleVersion"] = version+hg_output
list.writeToFile('Info.plist', :atomically => true)
