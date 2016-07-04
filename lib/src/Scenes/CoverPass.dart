part of ThreeDart.Scenes;

/// The render pass renders a cover over the whole scene.
class CoverPass implements RenderPass {

  /// The camara describing the view of the scene.
  Views.Camara _camara;

  /// The target defining the storage to render to.
  Views.Target _target;

  /// The default technique to render with.
  Techniques.Technique _tech;

  /// The box entity to render.
  Core.Entity _box;

  /// Event emitted on an redner for this pass.
  Core.Event _onRender;

  /// Creates a new cover render pass.
  CoverPass({
      Views.Camara camara: null,
      Views.Target target: null,
      Techniques.Technique tech: null
    }) {
    this.camara = camara;
    this.target = target;
    this.tech = tech;
    this._box = new Core.Entity()
      ..shape = Shapes.square();
    this._onRender = new Core.Event();
  }

  /// Creates a new cover render pass preset with a skybox technique.
  /// The given [boxTexture] is the cube texture of the skybox.
  factory CoverPass.skybox(Textures.TextureCube boxTexture) {
    return new CoverPass()
      ..tech = new Techniques.Skybox(boxTexture: boxTexture);
  }

  /// The camara describing the view of the scene.
  /// If null is set, the camara is set to an IdentityCamara.
  Views.Camara get camara => this._camara;
  set camara(Views.Camara camara) =>
    this._camara = (camara == null)? new Views.IdentityCamara(): camara;

  /// The target defining the storage to render to.
  /// If null is set, the target is set to an FrontTarget.
  Views.Target get target => this._target;
  set target(Views.Target target) =>
    this._target = (target == null)? new Views.FrontTarget(): target;

  /// The default technique to render with.
  Techniques.Technique get tech => this._tech;
  set tech(Techniques.Technique tech) => this._tech = tech;

  /// Event emitted on an redner for this pass.
  Core.Event get onRender => this._onRender;

  /// Render the scene with the given [state].
  void render(Core.RenderState state) {
    state.pushTechnique(this._tech);
    this._target.bind(state);
    this._camara.bind(state);

    if (this._tech != null) this._tech.update(state);
    this._box.update(state);
    this._box.render(state);

    Core.StateEventArgs args = new Core.StateEventArgs(this, state);
    this._onRender.emit(args);

    this._camara.unbind(state);
    this._target.unbind(state);
    state.popTechnique();
  }
}
