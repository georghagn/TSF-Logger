|<sub>🇬🇧 [German translation →](README.de.md)</sub>|
|----:|
|    |

|[![Pharo Version](https://img.shields.io/badge/Pharo-12.0%2B-blue.svg)](https://pharo.org)|[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE) [![Dependencies](https://img.shields.io/badge/dependencies-zero-brightgreen.svg)](#)|
|----|----|
|![TSF-Logger Logo](logo-logger.png)| ***TSF-Logger***<br>A robust, thread-safe, lightweight and zero-dependency Logging Framework for Pharo Smalltalk. Part of the **Tiny Smalltalk Framework Suite**|

<sup>***TSF*** stands for ***Tiny Smalltalk Framework*** — a collection of minimalist tools for robust applications.</sup>

## Overview

The *TSF-Logger* Frameworkis a simple, lightweight, and ready-to-use logger with log-level support. It follows a modular approach based on the Strategy and Decorator pattern.


## Key Features:

  * **Tiny:** Minimal code footprint, zero external dependencies.
  * **High-Speed:** Block support for lazy evaluation, Async-Logging support.
  * **Robust:** "Open-Write-Close" strategy for file appenders (fully compatible with external log rotation tools).
  * **Simple:** "Convention over Configuration" – `TsfLogger new` works out of the box.

## Installation

```smalltalk
Metacello new
    baseline: 'TsfLogger';
    repository: 'github://georghagn/TSF-Logger';
    load.
```

## Quick Start

```smalltalk
| log |
log := TsfLogger new. "Default: Writes to Transcript"

log info: 'System started'.
log warn: [ 'Warning, value is: ', expensiveCalculation printString ]. "Lazy Evaluation"
```

## Features & Configuration

### Logger Instantiation

```smalltalk
"Simple (Transcript)"
log := TsfLogger new.

"Custom (File + JSON)"
fileAppender := TsfFileAppender newOn: (FileSystem disk workingDirectory / 'app.json').
fileAppender formatter: TsfJsonLogFormatter new.

log := TsfLogger new
    clearAppenders;
    addAppender: fileAppender;
    yourself.
```

### Async Logging (High Performance)

For critical performance paths, any appender can be wrapped in an asynchronous worker. This prevents the logging process from blocking the main application thread.

```smalltalk
fastAppender := TsfAsyncLogAppender decorate: (TsfFileAppender newOn: 'server.log' asFileReference).
log addAppender: fastAppender.

"Important during shutdown to ensure queue is empty:"
fastAppender flush. 
```

### Log Levels

Available levels: `debug`, `info`, `warn`, `error`, `fatal`.
The level can be changed at runtime:

```smalltalk
log level: #ERROR. "Ignores everything below Error"
```


## Development-Process & Credits

Special thanks go to my AI sparring partner for the intensive and valuable discussions during the design phase. The AI's ability to quickly outline different architectural approaches and weigh their pros and cons significantly accelerated the development of `TSF-Logger` and improved the robustness of the final result.


## License

MIT

## Contact

If you have any questions or are interested in this project, you can reach me at
📧 **dev.georgh [at] hconsult.biz**

<sup>*(Please do not send inquiries to the private GitHub account addresses.)*</sup>



