let project = new Project('TrilateralKha_jigsawx');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('src');
project.addLibrary('trilateral');
project.addLibrary('trilateralXtra');
project.addLibrary('hxPolyK');
project.addLibrary('poly2trihx');
//project.addParameter('-dce no');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve( project );