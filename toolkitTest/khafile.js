let project = new Project('KhaQuick');
project.addAssets('assets/**');
project.addSources('src');
project.addShaders('src/Shaders/**');
project.addSources('samples')
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
project.addLibrary('khaMath');
project.addLibrary('trilateral');
resolve( project );