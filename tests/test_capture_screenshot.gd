extends SceneTree

func _init() -> void:
	print("[ScreenshotTest] Starting visual render test...")
	var world_scene: PackedScene = load("res://scenes/world/GameWorld.tscn")
	var world: GameWorld = world_scene.instantiate()
	root.add_child(world)

	for i in range(30):
		await process_frame

	var img: Image = root.get_viewport().get_texture().get_image()
	var out_path: String = "C:/Users/бубпбрб/.gemini/antigravity/brain/b7f4848f-c292-4a81-8422-c9813102921d/test_render_stage1.png"
	var err: Error = img.save_png(out_path)
	print("[ScreenshotTest] Saved screenshot to %s (result: %d)" % [out_path, err])
	quit(0)
