let project = new Project('TrilateralKha_graphics2');
project.addAssets('assets/**');
project.addSources('src');
project.addShaders('src/Shaders/**');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
project.addLibrary('trilateral');
resolve( project );