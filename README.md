# Swift-Debugger package

A Swift Debugger Package for Atom!

## Shortcuts
alt-r to hide/show the debugger view

alt-shift-r to toggle breakpoints at the current line

## How to use

### Install using APM
```
$ apm install swift-debugger language-swift
```
`language-swift` package provides syntax highlighting

### Create a project
```
$ mkdir MySwiftProject && touch MySwiftProject/main.swift && touch MySwiftProject/Package.swift
```

### Open the folder in atom
```
$ atom MySwiftProject
```

###Give name to the swift package, Enter this in Package.swift
```objc
import PackageDescription

let package = Package(
    name: "MySwiftProject"
)
```

###Enter some sample code in main.swift 
```objc 
let myAwesomeString = "hey I am an awesome string"
print(myAwesomeString)
let awesomeInt = 500
print(awesomeInt)
```

### Press alt-r to open the debugger

![Swift Debugger](https://cdn-images-1.medium.com/max/1600/1*ZhoyYtvLzQhvCMjhtlpFxQ.png)

###Set executable and swift path for debugger

Enter this in the input box of the debugger
`e=MySwiftProject` (press enter)
`p=/home/aciid/swift/swift-2.2-SNAPSHOT-2015–12–01-b-ubuntu15.10/usr/bin` (press enter)
Debugger will print: "swift path set" and "executable path set" respectively

###Press "run" to build and run the code
![](https://cdn-images-1.medium.com/max/1600/1*G1w5YyDLhYfHWCynDD7p0A.png)

###alt-shift-r to toggle breakpoint at the current line
![](https://cdn-images-1.medium.com/max/1600/1*6ji_E4xS2rswKuTStTmqYQ.png)

After toggling the breakpoint, press run and then enter `p myAwesomeString` to print the object

More tutorial:
https://medium.com/@Aciid/hacking-atom-to-create-a-swift-ide-that-runs-on-linux-and-mac-c7d9520a0fac#.etzoon43j

