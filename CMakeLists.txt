# --- START OF FILE CMakeLists.txt ---

cmake_minimum_required(VERSION 3.16)
project(MyEngineProject VERSION 1.0 LANGUAGES CXX C) # Keep C for glad

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # Optional: Organizes files in IDEs

# --- Find Packages ---
find_package(SDL2 REQUIRED)
find_package(SDL2_mixer REQUIRED) # We'll try to use its variables/targets
find_package(OpenGL REQUIRED)
find_package(glm REQUIRED)

# --- Add ImGui Library Target ---
# (This section looks good, no changes needed here for audio MVP)
add_library(imgui_lib STATIC
    vendor/imgui/imgui.cpp
    vendor/imgui/imgui_draw.cpp
    vendor/imgui/imgui_tables.cpp
    vendor/imgui/imgui_widgets.cpp
    vendor/imgui/backends/imgui_impl_sdl2.cpp
    vendor/imgui/backends/imgui_impl_opengl3.cpp
)
target_include_directories(imgui_lib PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui"
    "${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui/backends"
    ${SDL2_INCLUDE_DIRS} # Correct: imgui_impl_sdl2 needs SDL2 headers
)
target_compile_definitions(imgui_lib PUBLIC IMGUI_IMPL_OPENGL_LOADER_GLAD)
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/vendor/imgui FILES
    vendor/imgui/imgui.cpp vendor/imgui/imgui_draw.cpp vendor/imgui/imgui_tables.cpp
    vendor/imgui/imgui_widgets.cpp vendor/imgui/backends/imgui_impl_sdl2.cpp
    vendor/imgui/backends/imgui_impl_opengl3.cpp
)

# --- Add Executable and Sources ---
add_executable(MyEngineApp
    src/main.cpp
    src/Application.cpp
    src/Renderer.cpp
    src/Shader.cpp
    # src/VertexArray.cpp # Ensure this is removed if truly not used
    src/Mesh.cpp
    src/Texture.cpp
    src/FileUtils.cpp
    src/glad.c
    # === NEW AUDIO MVP SOURCES ===
    src/audio/AudioProbeManager.cpp
    src/audio/AudioSystem.cpp
    src/audio/EmbeddedAcousticDataSource.cpp # Or whatever you name it
)
# Group project sources in IDE (Optional)
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/src FILES
    src/main.cpp src/Application.cpp src/Renderer.cpp src/Shader.cpp
    src/Mesh.cpp src/Texture.cpp src/FileUtils.cpp src/glad.c
)
# === NEW AUDIO SOURCE GROUP ===
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/src/audio FILES
    src/audio/AudioProbeManager.cpp
    src/audio/AudioSystem.cpp
    src/audio/EmbeddedAcousticDataSource.cpp
)

# ----> SET BUNDLE PROPERTY <----
if(APPLE)
    set_target_properties(MyEngineApp PROPERTIES MACOSX_BUNDLE True)
endif()

# --- Handle macOS Bundle Resources ---
# (This section looks good, no changes needed here for audio MVP)
if(APPLE)
    set(RESOURCE_DESTINATION "$<TARGET_BUNDLE_CONTENT_DIR:MyEngineApp>/Resources")
    set(ASSET_SRC_DIR "${CMAKE_SOURCE_DIR}/assets")
    set(SHADER_SRC_DIR "${CMAKE_SOURCE_DIR}/shaders")
    set(ASSET_DEST_DIR "${RESOURCE_DESTINATION}/assets")
    set(SHADER_DEST_DIR "${RESOURCE_DESTINATION}/shaders")

    if(EXISTS "${ASSET_SRC_DIR}")
        add_custom_command(TARGET MyEngineApp POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory "${ASSET_DEST_DIR}"
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${ASSET_SRC_DIR}" "${ASSET_DEST_DIR}"
            COMMENT "Copying assets to bundle" VERBATIM)
    else()
        message(WARNING "Source assets directory not found: ${ASSET_SRC_DIR}. Skipping asset copy.")
    endif()

    if(EXISTS "${SHADER_SRC_DIR}")
         add_custom_command(TARGET MyEngineApp POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory "${SHADER_DEST_DIR}"
            COMMAND ${CMAKE_COMMAND} -E copy_directory "${SHADER_SRC_DIR}" "${SHADER_DEST_DIR}"
            COMMENT "Copying shaders to bundle" VERBATIM)
    else()
         message(WARNING "Source shaders directory not found: ${SHADER_SRC_DIR}. Skipping shader copy.")
    endif()
else()
     message(STATUS "Not on Apple, skipping bundle resource copy commands.")
endif()


# --- Target Include Directories (for MyEngineApp) ---
target_include_directories(MyEngineApp PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/include"     # Project includes
    "${CMAKE_CURRENT_SOURCE_DIR}/include/audio" # === NEW AUDIO MVP INCLUDE DIR ===
    "${CMAKE_CURRENT_SOURCE_DIR}/vendor/libs"  # For stb_image, tiny_obj_loader
    # Using variables/targets from find_package is preferred
    ${SDL2_INCLUDE_DIRS}
    ${SDL2_MIXER_INCLUDE_DIRS} # Use variable from find_package(SDL2_mixer)
    ${GLM_INCLUDE_DIRS}        # Should be provided by find_package(glm)
    # If you added nlohmann/json to vendor:
    # "${CMAKE_CURRENT_SOURCE_DIR}/vendor/nlohmann_json/include" # Or wherever its single header is
)

# --- Target Link Libraries (for MyEngineApp) ---
target_link_libraries(MyEngineApp PRIVATE
    imgui_lib       # Link the ImGui static library
    SDL2::SDL2      # Modern CMake target for SDL2
    # Try to use the imported target or library variable for SDL2_mixer
    # Option 1: If find_package(SDL2_mixer) provides SDL2::mixer (modern, preferred)
    # SDL2::mixer
    # Option 2: If find_package(SDL2_mixer) provides SDL2_MIXER_LIBRARIES (older)
    ${SDL2_MIXER_LIBRARIES}
    # If neither of the above works and you MUST use the hardcoded path, keep it as a last resort
    # and investigate why find_package isn't working fully.
    # "/opt/homebrew/opt/sdl2_mixer/lib/libSDL2_mixer.dylib" # Last resort
    glm::glm        # Modern CMake target for GLM
    ${OPENGL_LIBRARIES}
)

# Add macOS Frameworks (for MyEngineApp)
if(APPLE)
    target_link_libraries(MyEngineApp PRIVATE
        "-framework Cocoa"
        "-framework IOKit"
        "-framework CoreVideo"
        "-framework CoreAudio"
        "-framework AudioToolbox"
        "-framework Metal"
        "-framework OpenGL"
    )
endif()

# --- END OF FILE CMakeLists.txt ---