
class ApplicationDocument extends testTrilateral.TestFlash
{
   public function new()
   {
      #if nme
      var added:nme.display.DisplayObject = null;
      ApplicationMain.setAndroidViewHaxeObject(this);
      if (Std.is(this, nme.display.DisplayObject))
      {
         added = cast this;
         nme.Lib.current.addChild(added);
      }
      #end

      ApplicationBoot.callSuper();

      #if nme
      if (added!=null && added.stage!=null)
      {
         added.dispatchEvent(new nme.events.Event(nme.events.Event.ADDED_TO_STAGE, false, false));
         added.dispatchEvent(new nme.events.Event(nme.events.Event.ADDED, false, false));
      }
      #end
   }
}

