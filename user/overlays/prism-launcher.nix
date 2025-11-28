final: prev: {
  prismlauncher = prev.prismlauncher.override {
    additionalPrograms = [ prev.ffmpeg ];

    jdks = with prev; [
      graalvmPackages.graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  };
}

