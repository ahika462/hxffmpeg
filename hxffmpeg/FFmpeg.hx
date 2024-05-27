package hxffmpeg;

import sys.FileSystem;
import sys.thread.Thread;
import sys.io.Process;
import haxe.io.Path;
import haxe.macro.Compiler;

private final binaries = Compiler.getDefine('FFMPEG_BINARIES') ?? './';
private function getBinary(name:String):String {
	return Path.join(['./', binaries, name]);
}

typedef FFmpegParams = {
	expr:String,
	output:String
}

function FFmpeg(params:FFmpegParams, force = false, async = false, ?callback:()->Void) {
	if (FileSystem.exists(params.output)) {
		if (force) FileSystem.deleteFile(params.output);
		else return;
	}

	var result = Sys.command(getBinary('ffmpeg'), params.expr.split(' ').concat([params.output]));
	if (result != 0) {
		throw 'FFmpeg error';
		return;
	}

	/*var process = new Process(getBinary('ffmpeg'), params.expr.split(' ').concat([params.output]));

	if (process.exitCode() != 0) {
		throw 'FFmpeg error';
		return;
	}*/

	if (async) {
		Thread.create(() -> {
			while (!FileSystem.exists(params.output)) {
				// waiting
			}
			callback();
		});
	}
	while (!FileSystem.exists(params.output)) {
		// waiting
	}
}

typedef FFplayParams = {
	expr:String
}

function FFplay(params:FFplayParams) {
	var result = Sys.command(getBinary('ffplay'), params.expr.split(' '));
	if (result != 0) throw 'FFplay error';
	/*var process = new Process(getBinary('ffplay'), params.expr.split(' '));
	if (process.exitCode() != 0)
		throw 'FFplay error';*/
}

typedef FFprobeParams = {
	expr:String
}

function FFprobe(params:FFprobeParams) {
	var result = Sys.command(getBinary('ffprobe'), params.expr.split(' '));
	if (result != 0) throw 'FFprobe error';

	/*var process = new Process(getBinary('ffprobe'), params.expr.split(' '));
	if (process.exitCode() != 0) throw 'FFprobe error';*/
}