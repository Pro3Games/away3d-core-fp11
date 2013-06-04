package com.pro3games.particle.jumpStart {
	import away3d.core.managers.Stage3DProxy;
	import away3d.entities.Mesh;

	public class JumpStartCollector implements JumpStartTraverser {
		
		private var fJumpStartersStack:Vector.<JumpStarter> = null;
		private var fJumpStarter:JumpStarter = null;
		private var fStage3DProxy:Stage3DProxy = null;
		
		public function JumpStartCollector() {
			fJumpStartersStack = new Vector.<JumpStarter>();
		}
		
		public function clear():void {
			fJumpStarter = null;
			fJumpStartersStack.length = 0;
			fStage3DProxy = null;
		}
		
		public function reset(stage3DProxy:Stage3DProxy):void {
			fStage3DProxy = stage3DProxy;
			pushJumpStarter();
		}

		public function traverse(jumpStartNode:JumpStartNode):void {
			jumpStartNode.acceptTraverser(this);
		}
		
		public function apply(jumpStartee:JumpStartee):void {
			fJumpStarter.apply(jumpStartee);
		}
		
		public function proceed():Boolean {
			var jumpStarter:JumpStarter = fJumpStartersStack[0];
			if (jumpStarter.hasJumpStartees() && !jumpStarter.proceed()) {
				JumpStarter.put(jumpStarter);
				fJumpStartersStack.shift();
			}
			return (fJumpStartersStack.length > 0);
		}
		
		public function pushJumpStarter(mesh:Mesh = null):void {
			fJumpStarter = JumpStarter.get(fStage3DProxy, mesh);
			fJumpStartersStack.push(fJumpStarter);
		}
	}
}
