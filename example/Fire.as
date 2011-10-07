package 
{
	import a3dparticle.animators.actions.AccelerateAction;
	import a3dparticle.animators.actions.ChangeColorByLifeAction;
	import a3dparticle.animators.actions.DriftAction;
	import a3dparticle.animators.actions.OffestDistanceAction;
	import a3dparticle.animators.actions.PerParticleAction;
	import a3dparticle.animators.actions.ScaleByTimeAction;
	import a3dparticle.animators.actions.VelocityAction;
	import a3dparticle.materials.SimpleParticleMaterial;
	import a3dparticle.ParticlesContainer;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.primitives.Sphere;
	import away3d.primitives.WireframeAxesGrid;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author liaocheng
	 */
	[SWF(width="1024", height="768", frameRate="60")]
	public class Fire extends Sprite 
	{
		protected var _view:View3D;
		
		private var particle:ParticlesContainer;
		
		public function Fire():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// entry point
			_view = new View3D();
			_view.width = 1024;
			_view.height = 768;
			_view.antiAlias = 4;
			addChild(_view);
			addEventListener(Event.ENTER_FRAME, onRender);
			addChild(new AwayStats(_view));
			new HoverDragController(_view.camera, stage);
			_view.scene.addChild(new WireframeAxesGrid(4,1000));
			initScene();
		}
		
		
		
		private function initScene():void
		{
			var material:SimpleParticleMaterial = new SimpleParticleMaterial(new BitmapData(2, 2, true, 0xFFFFFFFF));
			particle = new ParticlesContainer(1800,material);
			_view.scene.addChild(particle);
			
			var sphere:Sphere = new Sphere(null, 10, 4, 4);
			
			particle.startTimeFun = function(index:uint):Number { return 1+Math.random()*3; };
			particle.endTimeFun = function(index:uint):Number { return Math.random() * 2; };
			particle.loop = true;
			
			var action:PerParticleAction = new VelocityAction(function(index:uint):Vector3D { return new Vector3D(Math.random()*100-50,Math.random()*300,Math.random()*100-50); } );
			particle.addPerParticleAction(action);
			
			var action2:AccelerateAction = new AccelerateAction(new Vector3D(0, 0, 0));
			particle.addAllParticleAction(action2);
			
			var action3:OffestDistanceAction = new OffestDistanceAction(function(index:uint):Vector3D { return new Vector3D(Math.random()*70-35,0,Math.random()*70-35);} );
			particle.addPerParticleAction(action3);
			
			var action4:ChangeColorByLifeAction = new ChangeColorByLifeAction(new ColorTransform(1,1,0.2,0.8,0,0),new ColorTransform(1,0,0,0.1,0,0) );
			particle.addAllParticleAction(action4);
			
			particle.generate(sphere.geometry.subGeometries[0]);
			particle.start();
			
		}

		
		private function onRender(e:Event):void
		{
			_view.render();
		}
		private function onStageResize(e:Event):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
	}
	
}