#!/bin/zsh

echo "Creating PhysicsSolverSDK directory structure..."
echo ""

# --- Root SDK directory ---
mkdir -p PhysicsSolverSDK
cd PhysicsSolverSDK || exit
echo "Created and changed to PhysicsSolverSDK/"
echo ""

# --- Public Headers ---
echo "Creating include/ structure..."
mkdir -p include/PhysicsSolverSDK/{acoustics,optics,mechanics,fluids,particles,multiphysics,ai,core,io}
echo "  Done."
echo ""

# --- Source Code ---
echo "Creating src/ structure..."
mkdir -p src/acoustics/{wave_based,geometric,hybrid,io}
mkdir -p src/optics/{transport,wave_optics,phenomena,io}
mkdir -p src/mechanics/{rigid_body,soft_body,collision,common}
mkdir -p src/fluids/{eulerian,lagrangian,common}
mkdir -p src/particles/{nbody,dem,common}
mkdir -p src/multiphysics
mkdir -p src/ai/{scene_analysis,surrogates,compression,optimizers,differentiable_physics}
mkdir -p src/core/{math,geometry,scene,numerical,common}
mkdir -p src/io/{usd,serialization,formats}
mkdir -p src/hypervisor_core
echo "  Done."
echo ""

# --- External Libraries ---
echo "Creating external/ structure..."
mkdir -p external/{openusd,onnxruntime,glm,eigen,tbb,nlohmann_json}
echo "  Done."
echo ""

# --- Tools ---
echo "Creating tools/ directory..."
mkdir -p tools
echo "  Done."
echo ""

# --- Examples ---
echo "Creating examples/ structure..."
mkdir -p examples/{acoustics_L_hallway,optics_cornell_box}
echo "  Done."
echo ""

# --- Tests ---
echo "Creating tests/ structure..."
mkdir -p tests/{acoustics,optics,core}
echo "  Done."
echo ""

# --- Data (Sample Inputs) ---
echo "Creating data/ structure..."
mkdir -p data/scenes
mkdir -p data/validation_data/acoustic_benchmark1
echo "  Done."
echo ""

# --- Documentation ---
echo "Creating docs/ structure..."
mkdir -p docs/source
echo "  Done."
echo ""

echo "PhysicsSolverSDK directory structure created successfully!"
echo "You can find it in: $(pwd)"
