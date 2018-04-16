let project = new Project('Trilateral_ellipticalArc');
project.addShaders('Shaders/**');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('PolyPainter');
project.windowOptions.width = 800;
project.windowOptions.height = 600;
resolve( project );