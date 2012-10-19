package away3d.animators.nodes
{
	import away3d.animators.data.ParticleAnimationSetting;
	import away3d.animators.states.ParticleColorByLifeGlobalState;
	import away3d.animators.utils.ParticleAnimationCompiler;
	import away3d.materials.compilation.ShaderRegisterElement;
	import away3d.materials.passes.MaterialPassBase;
	import flash.geom.ColorTransform;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParticleColorByLifeGlobalNode extends GlobalParticleNodeBase
	{
		public static const NAME:String = "ParticleColorByLifeGlobalNode";
		public static const START_MULTIPLIER_CONSTANT_REGISTER:int = 0;
		public static const DELTA_MULTIPLIER_CONSTANT_REGISTER:int = 1;
		public static const START_OFFSET_CONSTANT_REGISTER:int = 2;
		public static const DELTA_OFFSET_CONSTANT_REGISTER:int = 3;
		
		
		private var _hasMult:Boolean;
		private var _hasOffset:Boolean;
		
		private var _startMultiplierData:Vector.<Number>;
		private var _deltaMultiplierData:Vector.<Number>;
		private var _startOffsetData:Vector.<Number>;
		private var _deltaOffsetData:Vector.<Number>;
		
		private var _startColor:ColorTransform;
		private var _endColor:ColorTransform;
		
		public function ParticleColorByLifeGlobalNode(startColor:ColorTransform, endColor:ColorTransform, multiple:Boolean = true, add:Boolean = true)
		{
			super(NAME);
			_stateClass = ParticleColorByLifeGlobalState;
			
			_hasMult = multiple;
			_hasOffset = add;
			_startColor = startColor;
			_endColor = endColor;
			
			reset();
		}
		
		override public function processAnimationSetting(setting:ParticleAnimationSetting):void
		{
			setting.hasColorNode = true;
		}
		
		private function reset():void
		{
			_startMultiplierData = Vector.<Number>([_startColor.redMultiplier , _startColor.greenMultiplier , _startColor.blueMultiplier , _startColor.alphaMultiplier ]);
			_deltaMultiplierData = Vector.<Number>([(_endColor.redMultiplier - _startColor.redMultiplier) , (_endColor.greenMultiplier - _startColor.greenMultiplier) , (_endColor.blueMultiplier - _startColor.blueMultiplier) , (_endColor.alphaMultiplier - _startColor.alphaMultiplier)]);
			_startOffsetData = Vector.<Number>([_startColor.redOffset / 256, _startColor.greenOffset / 256, _startColor.blueOffset / 256, _startColor.alphaOffset / 256]);
			_deltaOffsetData = Vector.<Number>([(_endColor.redOffset - _startColor.redOffset) / 256, (endColor.greenOffset - _startColor.greenOffset) / 256, (endColor.blueOffset - _startColor.blueOffset ) / 256, (endColor.alphaOffset - startColor.alphaOffset) / 256]);
		}
		
		public function set startColor(value:ColorTransform):void
		{
			_startColor = value;
			reset();
		}
		public function get startColor():ColorTransform
		{
			return _startColor;
		}
		public function set endColor(value:ColorTransform):void
		{
			_endColor = value;
			reset();
		}
		public function get endColor():ColorTransform
		{
			return _endColor;
		}
		
		public function get needMultiple():Boolean
		{
			return _hasMult;
		}
		public function get needOffset():Boolean
		{
			return _hasOffset;
		}
		
		public function get startMultiplierData():Vector.<Number>
		{
			return _startMultiplierData;
		}
		public function get deltaMultiplierData():Vector.<Number>
		{
			return _deltaMultiplierData;
		}
		public function get startOffsetData():Vector.<Number>
		{
			return _startOffsetData;
		}
		public function get deltaOffsetData():Vector.<Number>
		{
			return _deltaOffsetData;
		}
		
		
		override public function getAGALFragmentCode(pass:MaterialPassBase, sharedSetting:ParticleAnimationSetting, activatedCompiler:ParticleAnimationCompiler) : String
		{
			if (activatedCompiler.needFragmentAnimation && sharedSetting.hasColorNode)
			{
				if (_hasMult)
				{
					var startMultiplierConst:ShaderRegisterElement = activatedCompiler.getFreeFragmentConstant();
					var deltaMultiplierConst:ShaderRegisterElement = activatedCompiler.getFreeFragmentConstant();
					activatedCompiler.setRegisterIndex(this, START_MULTIPLIER_CONSTANT_REGISTER, startMultiplierConst.index);
					activatedCompiler.setRegisterIndex(this, DELTA_MULTIPLIER_CONSTANT_REGISTER, deltaMultiplierConst.index);
				}
				if (_hasOffset)
				{
					var startOffsetConst:ShaderRegisterElement = activatedCompiler.getFreeFragmentConstant();
					var deltaOffsetConst:ShaderRegisterElement = activatedCompiler.getFreeFragmentConstant();
					activatedCompiler.setRegisterIndex(this, START_OFFSET_CONSTANT_REGISTER, startOffsetConst.index);
					activatedCompiler.setRegisterIndex(this, DELTA_OFFSET_CONSTANT_REGISTER, deltaOffsetConst.index);
				}
				
				var temp:ShaderRegisterElement = activatedCompiler.getFreeFragmentVectorTemp();
				
				var code:String = "";
				
				if (_hasMult)
				{
					code += "mul " + temp.toString() + "," + deltaMultiplierConst.toString() + "," +  activatedCompiler.fragmentLife.toString()+ "\n";
					code += "add " + temp.toString() + "," + temp.toString() + "," + startMultiplierConst.toString() + "\n";
					code += "mul " + activatedCompiler.colorTarget.toString() +"," + temp.toString() + "," + activatedCompiler.colorTarget.toString() + "\n";
				}
				if (_hasOffset)
				{
					code += "mul " + temp.toString() + "," + activatedCompiler.fragmentLife.toString() +"," + deltaOffsetConst.toString() + "\n";
					code += "add " + temp.toString() + "," + temp.toString() +"," + startOffsetConst.toString() + "\n";
					code += "add " + activatedCompiler.colorTarget.toString() +"," +temp.toString() + "," + activatedCompiler.colorTarget.toString() + "\n";
				}
				return code;
			}
			else
			{
				return "";
			}
		}
		
	}

}