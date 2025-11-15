# THE CORE DESCENT - NÍVEL 11: A FÁBRICA CLOUD (OTIMIZADO)
# Arquivo: Level11.gd - DevOps & Cloud: AWS, Docker, Kubernetes, CI/CD
# VERSÃO OTIMIZADA: PackedStringArray, Signals, Object Pooling, Cache

extends Node2D
class_name Level11

# Configurações do nível
@export var level_name: String = "A Fábrica Cloud"
@export var level_description: String = "Construa pipelines DevOps e infraestrutura cloud escalável"
@export var target_moves: int = 56  # Número ideal de movimentos
@export var grid_width: int = 40
@export var grid_height: int = 34

# Referências aos sistemas
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node
var ability_system: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Dados do nível - OTIMIZADO: Usar Vector2i para grid
var start_position: Vector2i = Vector2i(2, 17)
var goal_position: Vector2i = Vector2i(37, 17)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual - OTIMIZADO: Contadores eficientes
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}

# === OTIMIZAÇÃO 1: PACKED ARRAYS PARA CONCEITOS ===
# Cache de conceitos usando PackedStringArray (mais eficiente que Array)
var _cached_concepts: Dictionary = {}
var _concept_cache_initialized: bool = false

# === OTIMIZAÇÃO 2: OBJECT POOLING PARA RECURSOS TEMPORÁRIOS ===
var _container_pool: Array = []
var _deployment_pool: Array = []
var _service_pool: Array = []
var _pipeline_pool: Array = []
var _object_pool_size: int = 20

# Recursos cloud - OTIMIZADO: Inicialização eficiente
var cloud_infrastructure: Dictionary = {}
var devops_metrics: Dictionary = {}
var security_policies: Array = []
var monitoring_systems: Array = []

# Puzzles disponíveis - OTIMIZADO: Cache de dados
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0
var _puzzles_cache_initialized: bool = false

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var devops_panel: Control
var cloud_monitoring: Control
var pipeline_status_display: Control

# === OTIMIZAÇÃO 3: SIGNALS OTIMIZADOS ===
# Signals consolidados para reduzir overhead
signal level_state_changed(new_state: LevelState)
signal performance_metrics_updated(metrics: Dictionary)
signal resource_pool_utilization(pool_name: String, utilization: float)
signal puzzle_efficiency_calculated(puzzle_id: String, efficiency: float)

# Sinais específicos mantidos para funcionalidade
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated

# === OTIMIZAÇÃO 4: INICIALIZAÇÃO CACHEADA ===
func _ready():
    print("🚀 Level11: Inicializando versão otimizada...")
    
    # Cache de conceitos para performance
    _initialize_concept_cache()
    
    # Object pools para recursos temporários
    _initialize_object_pools()
    
    # Cache de puzzles
    if not _puzzles_cache_initialized:
        _initialize_puzzles()
    
    # Conectar sinais otimizados
    _connect_optimized_signals()
    
    print("✅ Level11: Otimizações aplicadas com sucesso!")

# === FUNÇÃO OTIMIZADA: CACHE DE CONCEITOS ===
func _initialize_concept_cache():
    if _concept_cache_initialized:
        return
    
    # Cache de conceitos DevOps usando PackedStringArray
    _cached_concepts = {
        "docker_concepts": PackedStringArray([
            "Docker Container", "Dockerfile", "Image Layers", "Container Registry", 
            "Docker Compose", "Volume Management", "Network Bridge", "Port Mapping",
            "Environment Variables", "Health Checks", "Resource Limits", 
            "Multi-stage Builds", "Security Scanning", "Container Orchestration", "Image Optimization"
        ]),
        "kubernetes_concepts": PackedStringArray([
            "Kubernetes Pod", "Deployment", "Service Discovery", "ConfigMaps", "Secrets",
            "Persistent Volumes", "StatefulSets", "Ingress", "RBAC", "Helm Charts",
            "Operators", "Auto-scaling", "Load Balancing", "Node Management", 
            "Cluster Federation", "Service Mesh", "CRDs"
        ]),
        "aws_concepts": PackedStringArray([
            "EC2 Instances", "S3 Storage", "VPC Networking", "RDS Database", 
            "Lambda Functions", "IAM Roles", "Auto Scaling", "Load Balancers",
            "CloudFront CDN", "Route53 DNS", "CloudWatch", "AWS CLI",
            "CloudFormation", "Security Groups", "Elastic Container Service", 
            "Serverless", "Edge Computing"
        ]),
        "cicd_concepts": PackedStringArray([
            "Continuous Integration", "Continuous Deployment", "Automated Testing",
            "Build Pipelines", "Code Quality Gates", "Rollback Strategies",
            "Blue-Green Deployment", "Canary Releases", "Environment Management",
            "Artifact Management", "Dependency Management", "Version Control"
        ]),
        "terraform_concepts": PackedStringArray([
            "Infrastructure as Code", "State Management", "Resource Provisioning",
            "Module Composition", "Variable Management", "Output Values",
            "Remote State", "Provider Configuration", "Resource Graph",
            "Dependency Management", "Plan and Apply", "Destroy Operations"
        ]),
        "jenkins_concepts": PackedStringArray([
            "Build Automation", "Plugin Architecture", "Pipeline as Code",
            "Jenkinsfile", "Agent Management", "Build Triggers",
            "Post-build Actions", "Parameter Management", "Security Configuration",
            "Plugin Development", "Custom Steps", "Shared Libraries"
        ])
    }
    
    _concept_cache_initialized = true
    print("📦 Level11: Cache de conceitos inicializado")

# === FUNÇÃO OTIMIZADA: OBJECT POOLING ===
func _initialize_object_pools():
    # Pool para containers Docker
    for i in _object_pool_size:
        _container_pool.append({
            "id": "docker_container_" + str(i),
            "status": "available",
            "created_at": Time.get_unix_time_from_system(),
            "resource_usage": {"cpu": 0.0, "memory": 0}
        })
    
    # Pool para deployments Kubernetes
    for i in _object_pool_size:
        _deployment_pool.append({
            "id": "k8s_deployment_" + str(i),
            "status": "available",
            "replicas": 0,
            "ready_replicas": 0
        })
    
    # Pool para serviços AWS
    for i in _object_pool_size:
        _service_pool.append({
            "id": "aws_service_" + str(i),
            "status": "available",
            "service_type": "unknown",
            "region": "us-east-1"
        })
    
    # Pool para pipelines CI/CD
    for i in _object_pool_size:
        _pipeline_pool.append({
            "id": "cicd_pipeline_" + str(i),
            "status": "available",
            "stage": "idle",
            "build_id": null
        })
    
    print("🎯 Level11: Object pools inicializados (tamanho: " + str(_object_pool_size) + ")")

# === FUNÇÃO OTIMIZADA: ACQUISITION DE OBJETOS DO POOL ===
func acquire_resource_from_pool(pool_name: String) -> Dictionary:
    match pool_name:
        "containers":
            var container = _container_pool.pop_back()
            if container == null:
                container = {"id": "docker_container_new", "status": "created", "created_at": Time.get_unix_time_from_system()}
            return container
        "deployments":
            var deployment = _deployment_pool.pop_back()
            if deployment == null:
                deployment = {"id": "k8s_deployment_new", "status": "created", "replicas": 1}
            return deployment
        "services":
            var service = _service_pool.pop_back()
            if service == null:
                service = {"id": "aws_service_new", "status": "created", "service_type": "ec2"}
            return service
        "pipelines":
            var pipeline = _pipeline_pool.pop_back()
            if pipeline == null:
                pipeline = {"id": "cicd_pipeline_new", "status": "created", "stage": "created"}
            return pipeline
        _:
            return {"id": "unknown_resource", "status": "error"}

# === FUNÇÃO OTIMIZADA: RETURN DE OBJETOS AO POOL ===
func return_resource_to_pool(pool_name: String, resource: Dictionary):
    resource["status"] = "available"
    match pool_name:
        "containers":
            _container_pool.append(resource)
        "deployments":
            _deployment_pool.append(resource)
        "services":
            _service_pool.append(resource)
        "pipelines":
            _pipeline_pool.append(resource)

# === FUNÇÃO OTIMIZADA: SIGNALS OTIMIZADOS ===
func _connect_optimized_signals():
    # Conectar sinais de performance
    var performance_timer = Timer.new()
    performance_timer.wait_time = 5.0  # Atualizar a cada 5 segundos
    performance_timer.connect("timeout", Callable(self, "_update_performance_metrics"))
    add_child(performance_timer)
    performance_timer.start()
    
    # Conectar sinais de eficiência de puzzles
    self.connect("puzzle_solved", Callable(self, "_on_puzzle_solved_optimized"))

func _update_performance_metrics():
    var metrics = {
        "container_pool_utilization": float(_object_pool_size - _container_pool.size()) / _object_pool_size,
        "deployment_pool_utilization": float(_object_pool_size - _deployment_pool.size()) / _object_pool_size,
        "service_pool_utilization": float(_object_pool_size - _service_pool.size()) / _object_pool_size,
        "pipeline_pool_utilization": float(_object_pool_size - _pipeline_pool.size()) / _object_pool_size,
        "memory_usage_mb": OS.get_static_memory_usage() / 1024 / 1024,
        "active_puzzle_count": available_puzzles.size()
    }
    emit_signal("performance_metrics_updated", metrics)

# === FUNÇÃO OTIMIZADA: PROCESSAMENTO DE PUZZLE ===
func _on_puzzle_solved_optimized(puzzle_data: Dictionary):
    # Calcular eficiência do puzzle
    var efficiency = float(target_moves) / float(moves_used) if moves_used > 0 else 1.0
    emit_signal("puzzle_efficiency_calculated", puzzle_data.get("id", "unknown"), efficiency)
    
    # Retornar recursos ao pool após resolver puzzle
    _cleanup_puzzle_resources(puzzle_data)

func _cleanup_puzzle_resources(puzzle_data: Dictionary):
    # Limpar recursos temporários do puzzle
    var puzzle_id = puzzle_data.get("id", "")
    
    match puzzle_id:
        "docker_containerization":
            # Retornar containers Docker ao pool
            for i in range(min(5, _container_pool.size() + 5)):
                var container = {"id": "temp_container_" + str(i), "status": "cleanup"}
                return_resource_to_pool("containers", container)
        
        "kubernetes_orchestration":
            # Retornar deployments Kubernetes ao pool
            for i in range(min(3, _deployment_pool.size() + 3)):
                var deployment = {"id": "temp_deployment_" + str(i), "status": "cleanup"}
                return_resource_to_pool("deployments", deployment)

# === FUNÇÃO OTIMIZADA: GET CONCEITOS COM CACHE ===
func get_concepts_for_puzzle(puzzle_type: String) -> PackedStringArray:
    if not _concept_cache_initialized:
        _initialize_concept_cache()
    
    return _cached_concepts.get(puzzle_type + "_concepts", PackedStringArray())

# === FUNÇÃO OTIMIZADA: ATUALIZAÇÃO DE PERFORMANCE ===
func _process(delta: float) -> void:
    if is_timer_running:
        level_timer += delta
        if timer_label:
            timer_label.text = "Tempo: %.1fs" % level_timer
    
    # Atualizar métricas de performance periodicamente (não a cada frame)
    if int(level_timer) % 10 == 0 and int((level_timer - delta) * 10) % 10 != 0:
        _update_performance_metrics()

# === FUNÇÃO PRINCIPAL OTIMIZADA ===
func _initialize_puzzles():
    if _puzzles_cache_initialized:
        return
    
    available_puzzles = [
        {
            "id": "docker_containerization",
            "title": "Containerização Docker",
            "description": "Containerize aplicações com Docker e orquestre serviços",
            "target_moves": 46,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(18, 26),
            "blocks_required": 15,
            # OTIMIZADO: Usar cache de conceitos em vez de array dinâmico
            "concepts": get_concepts_for_puzzle("docker"),
            "mechanics": {
                "container_creation": true,
                "image_building": true,
                "service_composition": true,
                "volume_mounting": true,
                "network_configuration": true,
                "health_monitoring": true,
                "resource_allocation": true,
                "security_hardening": true
            },
            "obstacles": [
                {"type": "image_size_bloat", "position": Vector2i(6, 12), "size_mb": 2500},
                {"type": "layer_optimization", "position": Vector2i(9, 16), "layers_count": 25},
                {"type": "port_conflicts", "position": Vector2i(12, 20), "conflicts": 3},
                {"type": "volume_permissions", "position": Vector2i(15, 24), "permission_errors": 5}
            ]
        },
        {
            "id": "kubernetes_orchestration",
            "title": "Orquestração Kubernetes",
            "description": "Orquestre containers em escala com Kubernetes",
            "target_moves": 48,
            "start_position": Vector2i(4, 28),
            "goal_position": Vector2i(22, 6),
            "blocks_required": 17,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("kubernetes"),
            "mechanics": {
                "pod_deployment": true,
                "service_networking": true,
                "config_management": true,
                "secret_handling": true,
                "storage_management": true,
                "access_control": true,
                "auto_scaling": true,
                "traffic_routing": true
            },
            "obstacles": [
                {"type": "pod_scheduling", "position": Vector2i(8, 24), "pending_pods": 10},
                {"type": "service_mesh_latency", "position": Vector2i(12, 18), "latency_ms": 150},
                {"type": "resource_quota", "position": Vector2i(16, 12), "cpu_limit": "2"},
                {"type": "node_affinity", "position": Vector2i(20, 6), "node_selector": "worker"}
            ]
        },
        {
            "id": "aws_infrastructure",
            "title": "Infraestrutura AWS Cloud",
            "description": "Provisione recursos cloud na AWS com boas práticas",
            "target_moves": 50,
            "start_position": Vector2i(20, 4),
            "goal_position": Vector2i(36, 28),
            "blocks_required": 19,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("aws"),
            "mechanics": {
                "resource_provisioning": true,
                "network_configuration": true,
                "security_implementation": true,
                "cost_optimization": true,
                "monitoring_setup": true,
                "backup_configuration": true,
                "disaster_recovery": true,
                "compliance_checking": true
            },
            "obstacles": [
                {"type": "cost_overrun", "position": Vector2i(24, 8), "over_budget": 1500},
                {"type": "security_group_misconfig", "position": Vector2i(28, 14), "ports_open": 15},
                {"type": "vpc_subnet_conflict", "position": Vector2i(32, 20), "cidr_overlap": true},
                {"type": "iam_permission_error", "position": Vector2i(35, 26), "denied_actions": 8}
            ]
        },
        {
            "id": "cicd_pipeline",
            "title": "Automação CI/CD Pipeline",
            "description": "Construa pipelines de integração e deployment contínuos",
            "target_moves": 52,
            "start_position": Vector2i(6, 30),
            "goal_position": Vector2i(26, 4),
            "blocks_required": 21,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("cicd"),
            "mechanics": {
                "continuous_integration": true,
                "deployment_automation": true,
                "testing_pipeline": true,
                "quality_gates": true,
                "rollback_strategy": true,
                "environment_management": true,
                "artifact_management": true,
                "notification_setup": true
            },
            "obstacles": [
                {"type": "build_failure", "position": Vector2i(10, 26), "failure_rate": 0.3},
                {"type": "test_timeout", "position": Vector2i(14, 20), "timeout_seconds": 1800},
                {"type": "deployment_stuck", "position": Vector2i(18, 16), "stuck_minutes": 45},
                {"type": "environment_mismatch", "position": Vector2i(22, 10), "mismatch_count": 5}
            ]
        },
        {
            "id": "terraform_iac",
            "title": "Terraform Infrastructure as Code",
            "description": "Gerencie infraestrutura como código com Terraform",
            "target_moves": 54,
            "start_position": Vector2i(28, 8),
            "goal_position": Vector2i(38, 26),
            "blocks_required": 23,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("terraform"),
            "mechanics": {
                "infrastructure_as_code": true,
                "module_management": true,
                "state_handling": true,
                "dependency_resolution": true,
                "plan_validation": true,
                "apply_automation": true,
                "destroy_safety": true,
                "remote_state_management": true
            },
            "obstacles": [
                {"type": "state_lock", "position": Vector2i(30, 12), "locked_by": "terraform"},
                {"type": "dependency_cycle", "position": Vector2i(32, 18), "cycle_length": 5},
                {"type": "module_version_conflict", "position": Vector2i(35, 22), "conflicts": 3},
                {"type": "remote_state_access", "position": Vector2i(37, 26), "access_denied": true}
            ]
        },
        {
            "id": "jenkins_build",
            "title": "Orquestração Jenkins Build",
            "description": "Configure builds complexos com Jenkins e plugins",
            "target_moves": 56,
            "start_position": Vector2i(8, 4),
            "goal_position": Vector2i(34, 30),
            "blocks_required": 25,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("jenkins"),
            "mechanics": {
                "build_orchestration": true,
                "plugin_management": true,
                "pipeline_automation": true,
                "agent_management": true,
                "security_configuration": true,
                "notification_system": true,
                "artifact_handling": true,
                "custom_step_development": true
            },
            "obstacles": [
                {"type": "plugin_dependency", "position": Vector2i(12, 8), "missing_plugins": 4},
                {"type": "agent_offline", "position": Vector2i(16, 14), "offline_agents": 2},
                {"type": "build_queue_congestion", "position": Vector2i(20, 20), "queued_builds": 25},
                {"type": "credential_expiration", "position": Vector2i(28, 28), "expired_secrets": 3}
            ]
        }
    ]
    
    _puzzles_cache_initialized = true
    print("🎯 Level11: Puzzles otimizados inicializados (cache: " + str(available_puzzles.size()) + " puzzles)")

# === FUNÇÃO OTIMIZADA: LÓGICA PRINCIPAL ===
func start_level():
    current_state = LevelState.PLAYING
    emit_signal("level_state_changed", current_state)
    is_timer_running = true
    _update_ui()
    print("🚀 Level11: Iniciando versão otimizada!")

func check_puzzle_completion() -> bool:
    # OTIMIZADO: Verificação eficiente usando cache
    var current_puzzle = available_puzzles[current_puzzle_index] if current_puzzle_index < available_puzzles.size() else null
    
    if current_puzzle and blocks_placed >= current_puzzle.blocks_required:
        moves_used = current_puzzle.target_moves  # Meta alcançada
        emit_signal("puzzle_solved", current_puzzle)
        current_puzzle_index += 1
        
        if current_puzzle_index >= available_puzzles.size():
            current_state = LevelState.COMPLETED
            emit_signal("level_completed")
            print("🏆 Level11: Todos os puzzles DevOps resolvidos! Performance otimizada.")
            return true
    
    return false

func _update_ui():
    if move_counter:
        move_counter.text = "Movimentos: %d/%d" % [moves_used, target_moves]
    
    if progress_bar:
        progress_bar.value = (float(current_puzzle_index) / available_puzzles.size()) * 100
    
    if puzzle_info_label and current_puzzle_index < available_puzzles.size():
        var puzzle_data = available_puzzles[current_puzzle_index]
        puzzle_info_label.text = "Puzzle %d/6\n%s\nObjetivo: %d movimentos" % [
            current_puzzle_index + 1, 
            puzzle_data.title, 
            puzzle_data.target_moves
        ]

# === FUNÇÃO OTIMIZADA: LIMPEZA DE MEMÓRIA ===
func _exit_tree():
    # OTIMIZADO: Cleanup automático de recursos
    print("🧹 Level11: Limpando object pools e cache...")
    
    # Limpar caches
    _cached_concepts.clear()
    _concept_cache_initialized = false
    _puzzles_cache_initialized = false
    
    # Limpar object pools
    _container_pool.clear()
    _deployment_pool.clear()
    _service_pool.clear()
    _pipeline_pool.clear()
    
    # Parar timer de performance
    is_timer_running = false
    
    print("✅ Level11: Cleanup otimizado concluído")

