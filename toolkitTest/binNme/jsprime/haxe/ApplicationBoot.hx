import haxe.macro.Expr;
import haxe.macro.Context;

class ApplicationBoot
{
   macro public static function canCallMain()
   {
      var p = Context.currentPos();

      switch(Context.getType("testTrilateral.TestFlash"))
      {
         case TInst(tref,_):
            for(stat in tref.get().statics.get())
               if (stat.name == "main")
                  return Context.parse("true", p);

         default:
      }
      return Context.parse("false", p);
   }

   macro public static function createInstance(inDefaultName:String = "ApplicationDocument")
   {
      var p = Context.currentPos();

      switch(Context.getType("testTrilateral.TestFlash"))
      {
         case TInst(tref,_):
            for(stat in tref.get().statics.get())
               if (stat.name == "main")
                  return Context.parse("testTrilateral.TestFlash.main()", p);

         default:
      }

      return Context.parse("new " + inDefaultName + "()", p);
   }

   macro public static function callSuper() {
      var p = Context.currentPos();

      switch(Context.getType("testTrilateral.TestFlash"))
      {
         case TInst(tref,_):
            if (tref.get().constructor != null)
               return Context.parse("super()", p);

         default:
      }
      return Context.parse("{}", p);
   }
}
