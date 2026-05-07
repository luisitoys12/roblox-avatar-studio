# ============================================================
# Avatar Payaso Infantil para Roblox R15
# Ejecutar desde Blender: Scripting > Run Script
# O via MCP: "ejecuta el script blender_clown_avatar.py"
# ============================================================
import bpy
import math

# Limpiar escena
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete()

# ========================
# MATERIALES
# ========================

def make_material(name, r, g, b, roughness=0.8):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs["Base Color"].default_value = (r, g, b, 1)
    bsdf.inputs["Roughness"].default_value = roughness
    return mat

# Paleta de colores payaso
mat_skin     = make_material("Skin_White",    1.0,  1.0,  1.0)   # cara blanca
mat_red      = make_material("Red_Paint",     0.9,  0.1,  0.1)   # nariz y boca
mat_blue     = make_material("Blue_Paint",    0.1,  0.3,  0.9)   # cejas
mat_yellow   = make_material("Yellow_Paint",  1.0,  0.85, 0.0)   # pelo
mat_body     = make_material("Body_Suit",     0.2,  0.6,  0.2)   # cuerpo verde
mat_pompom   = make_material("Pompom",        1.0,  0.3,  0.0)   # pompones naranja

# ========================
# CABEZA (Head)
# ========================
bpy.ops.mesh.primitive_uv_sphere_add(radius=0.5, location=(0, 0, 1.5))
head = bpy.context.object
head.name = "Head"
head.scale = (1.0, 0.85, 1.0)
bpy.ops.object.transform_apply(scale=True)
head.data.materials.append(mat_skin)

# --- Nariz roja (esfera grande) ---
bpy.ops.mesh.primitive_uv_sphere_add(radius=0.1, location=(0, -0.45, 1.5))
nose = bpy.context.object
nose.name = "Nose_Red"
nose.data.materials.append(mat_red)

# --- Ojo izquierdo (diamante azul) ---
bpy.ops.mesh.primitive_uv_sphere_add(radius=0.09, location=(-0.18, -0.42, 1.62))
eye_l = bpy.context.object
eye_l.name = "Eye_L"
eye_l.scale = (1.4, 0.4, 1.0)  # forma de diamante achatado
bpy.ops.object.transform_apply(scale=True)
eye_l.data.materials.append(mat_blue)

# --- Ojo derecho ---
bpy.ops.mesh.primitive_uv_sphere_add(radius=0.09, location=(0.18, -0.42, 1.62))
eye_r = bpy.context.object
eye_r.name = "Eye_R"
eye_r.scale = (1.4, 0.4, 1.0)
bpy.ops.object.transform_apply(scale=True)
eye_r.data.materials.append(mat_blue)

# --- Boca sonriente (toro aplanado) ---
bpy.ops.mesh.primitive_torus_add(
    location=(0, -0.44, 1.36),
    major_radius=0.15,
    minor_radius=0.035
)
mouth = bpy.context.object
mouth.name = "Mouth"
mouth.scale = (1.0, 0.4, 0.5)
bpy.ops.object.transform_apply(scale=True)
mouth.data.materials.append(mat_red)

# --- Mejillas rojas (círculos) ---
for x_pos in [-0.28, 0.28]:
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.08, location=(x_pos, -0.43, 1.44))
    cheek = bpy.context.object
    cheek.name = f"Cheek_{'L' if x_pos < 0 else 'R'}"
    cheek.scale = (1.0, 0.3, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    mat_cheek = make_material(f"Cheek_Mat_{x_pos}", 1.0, 0.4, 0.5, 0.9)
    cheek.data.materials.append(mat_cheek)

# ========================
# PELO (pompones amarillos)
# ========================
hair_positions = [
    (-0.45, 0.0, 1.85), (0.45, 0.0, 1.85),
    (-0.3,  0.0, 1.95), (0.3,  0.0, 1.95),
    (0.0,   0.0, 2.02),
    (-0.38, 0.0, 1.65), (0.38, 0.0, 1.65),
]
for i, pos in enumerate(hair_positions):
    r = 0.08 + (i % 3) * 0.02
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r, location=pos)
    pom = bpy.context.object
    pom.name = f"Hair_Pompom_{i}"
    pom.data.materials.append(mat_yellow)

# ========================
# TORSO (UpperTorso R15)
# ========================
bpy.ops.mesh.primitive_cube_add(location=(0, 0, 0.75))
torso = bpy.context.object
torso.name = "UpperTorso"
torso.scale = (0.5, 0.3, 0.45)
bpy.ops.object.transform_apply(scale=True)
torso.data.materials.append(mat_body)

# Pompones en el traje
for pos in [(0, -0.31, 0.92), (0, -0.31, 0.72), (0, -0.31, 0.52)]:
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.06, location=pos)
    pp = bpy.context.object
    pp.name = "Suit_Pompom"
    pp.data.materials.append(mat_pompom)

# ========================
# LOWER TORSO
# ========================
bpy.ops.mesh.primitive_cube_add(location=(0, 0, 0.32))
lower = bpy.context.object
lower.name = "LowerTorso"
lower.scale = (0.48, 0.28, 0.22)
bpy.ops.object.transform_apply(scale=True)
lower.data.materials.append(mat_body)

# ========================
# BRAZOS (UpperArm + LowerArm)
# ========================
for side, x in [('L', -0.65), ('R', 0.65)]:
    # Upper arm
    bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=0.4, location=(x, 0, 0.82))
    ua = bpy.context.object
    ua.name = f"UpperArm_{side}"
    ua.data.materials.append(mat_body)

    # Lower arm
    bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.38, location=(x, 0, 0.44))
    la = bpy.context.object
    la.name = f"LowerArm_{side}"
    la.data.materials.append(mat_body)

    # Hand
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.11, location=(x, 0, 0.24))
    hand = bpy.context.object
    hand.name = f"Hand_{side}"
    hand.scale = (1.0, 0.7, 0.8)
    bpy.ops.object.transform_apply(scale=True)
    mat_glove = make_material(f"Glove_{side}", 1.0, 1.0, 1.0)
    hand.data.materials.append(mat_glove)

# ========================
# PIERNAS (UpperLeg + LowerLeg)
# ========================
for side, x in [('L', -0.22), ('R', 0.22)]:
    # Upper leg
    bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.4, location=(x, 0, -0.02))
    ul = bpy.context.object
    ul.name = f"UpperLeg_{side}"
    ul.data.materials.append(mat_body)

    # Lower leg
    bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=0.38, location=(x, 0, -0.42))
    ll = bpy.context.object
    ll.name = f"LowerLeg_{side}"
    ll.data.materials.append(mat_body)

    # Pie (zapatos grandes de payaso)
    bpy.ops.mesh.primitive_cube_add(location=(x, -0.12, -0.66))
    foot = bpy.context.object
    foot.name = f"Foot_{side}"
    foot.scale = (0.18, 0.32, 0.1)
    bpy.ops.object.transform_apply(scale=True)
    mat_shoe = make_material(f"Shoe_{side}", 0.8, 0.1, 0.1)  # zapatos rojos
    foot.data.materials.append(mat_shoe)

# ========================
# CONFIGURAR CÁMARA Y LUZ
# ========================
bpy.ops.object.camera_add(location=(2.5, -2.5, 2.0))
cam = bpy.context.object
cam.rotation_euler = (math.radians(65), 0, math.radians(45))
bpy.context.scene.camera = cam

bpy.ops.object.light_add(type='SUN', location=(3, -3, 5))
light = bpy.context.object
light.data.energy = 3.0

# ========================
# SELECCIONAR TODO Y CENTRAR VISTA
# ========================
bpy.ops.object.select_all(action='SELECT')
bpy.ops.view3d.view_selected()

print("="*50)
print("✅ Avatar Payaso Infantil creado exitosamente")
print("Partes creadas:")
for obj in bpy.data.objects:
    print(f"  - {obj.name}")
print("="*50)
print("EXPORTAR como FBX:")
print("  File > Export > FBX (.fbx)")
print("  Settings: Armature > Add Leaf Bones OFF")
print("  Scale: 1.0, Forward: -Z, Up: Y")
print("="*50)
