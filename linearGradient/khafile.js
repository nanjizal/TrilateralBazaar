let project = new Project('TrilateralKha_linearGradient');
project.addShaders('Shaders/**');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('trilateralXtra');
project.addLibrary('hxPolyK');
project.addLibrary('poly2trihx');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve( project );