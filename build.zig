const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "kat",
        .target = target,
        .optimize = optimize,
    });

    lib.addCSourceFiles(.{ .files = &.{ "./hashtable.c", "./highlight.c" } });
    lib.addIncludePath(b.path("include"));
    lib.linkLibC();

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "kat",
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(b.path("include"));
    exe.addCSourceFile(.{ .file = b.path("./main.c") });
    exe.linkLibrary(lib);

    b.installArtifact(exe);

    const step = b.step("run", "Run the kat CLI");
    step.dependOn(&exe.step);
}
