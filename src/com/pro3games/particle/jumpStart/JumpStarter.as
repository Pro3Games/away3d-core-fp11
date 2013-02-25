package com.pro3games.particle.jumpStart {
	import away3d.core.managers.Stage3DProxy;
	import away3d.entities.Mesh;

	public class JumpStarter {
		
		private static const pool:Vector.<JumpStarter> = new Vector.<JumpStarter>();
		private static var top:uint = 0;

		public static function get(stage3DProxy:Stage3DProxy, mesh:Mesh = null):JumpStarter {
			var jumpStarter:JumpStarter = null;
			if (top > 0) {
				jumpStarter = pool[--top];
			} else {
				jumpStarter = new JumpStarter();
			}
			jumpStarter.reset(stage3DProxy, mesh);
			return jumpStarter;
		}
		
		public static function put(jumpStarter:JumpStarter):void {
			jumpStarter.clear();
			pool[top++] = jumpStarter;
		}
		
		public static function clearPool():void {
			pool.length = top = 0;
		}

		private var fJumpStarteesStack:Vector.<JumpStartee> = null;
		private var fIndezesStack:Vector.<uint> = null;
		
		private var fStage3DProxy:Stage3DProxy = null;
		private var fMesh:Mesh = null;
		
		public var index:uint = 0;

		public function JumpStarter() {
			fJumpStarteesStack = new Vector.<JumpStartee>();
			fIndezesStack = new Vector.<uint>();
		}
		
		public function clear():void {
			fJumpStarteesStack.length = 0;
			fIndezesStack.length = 0;

			fStage3DProxy = null;
			fMesh = null;

			index = 0;
		}
		
		public function reset(stage3DProxy:Stage3DProxy, mesh:Mesh = null):void {
			fStage3DProxy = stage3DProxy;
			fMesh = mesh;
		}
		
		public function apply(jumpStartee:JumpStartee):void {
			if (fJumpStarteesStack.indexOf(jumpStartee) < 0) {
				fJumpStarteesStack.push(jumpStartee);
				fIndezesStack.push(0);
			}
		}
		
		public function exit(jumpStartee:JumpStartee):void {
			var index:int = fJumpStarteesStack.indexOf(jumpStartee);
			if (index >= 0) {
				fJumpStarteesStack.splice(index, 1);
				fIndezesStack.splice(index, 1);
			}
		}
		
		public function hasJumpStartees():Boolean {
			return (fJumpStarteesStack.length > 0);
		}
		
		public function proceed():Boolean {
			if (fJumpStarteesStack.length > 0) {
				index = fIndezesStack[0];
				var jumpStartee:JumpStartee = fJumpStarteesStack[0];
				jumpStartee.jumpStart(this);
				if (fJumpStarteesStack.length > 0 && fJumpStarteesStack[0] == jumpStartee) {
					fIndezesStack[0] = index;
				}
			}
			return (fJumpStarteesStack.length > 0);
		}
		
		public function get stage3DProxy():Stage3DProxy {
			return fStage3DProxy;
		}

		public function get subContainer():Mesh {
			return fMesh;
		}
	}
}
