import bpy

# Habilitar el addon de Blender MCP
bpy.ops.preferences.addon_enable(module='blender_mcp_addon')
bpy.ops.wm.save_userpref()
print('✅ BlenderMCP addon habilitado')
