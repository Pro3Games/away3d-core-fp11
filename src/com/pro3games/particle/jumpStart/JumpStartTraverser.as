package com.pro3games.particle.jumpStart {
	import away3d.entities.Mesh;
	public interface JumpStartTraverser {

		function apply(jumpStartee:JumpStartee):void;
		function pushJumpStarter(mesh:Mesh = null):void;
	}
}
