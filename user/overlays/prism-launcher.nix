final: prev: {
  prismlauncher = final.prismlauncher.override {
    additionalPrograms = [ prev.ffmpeg ];

    jdks = with prev; [
      graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  };
}

