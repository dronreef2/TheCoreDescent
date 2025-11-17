# THE CORE DESCENT - NÍVEL 11: A FÁBRICA CLOUD
# Arquivo: Level11.gd - DevOps & Cloud: AWS, Docker, Kubernetes, CI/CD

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

# Dados do nível
var start_position: Vector2i = Vector2i(2, 17)
var goal_position: Vector2i = Vector2i(37, 17)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var _object_pool_size: int = 10
var _resource_pool: Array = []
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}
var docker_containers: Array = []
var kubernetes_deployments: Array = []
var aws_services: Array = []
var ci_cd_pipelines: Array = []
var terraform_modules: Array = []
var jenkins_jobs: Array = []
var cloud_infrastructure: Dictionary = {}
var devops_metrics: Dictionary = {}
var security_policies: Array = []
var monitoring_systems: Array = []

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var devops_panel: Control
var cloud_monitoring: Control
var pipeline_status_display: Control

# Sinais
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated
signal docker_container_deployed
signal kubernetes_service_deployed
signal aws_infrastructure_provisioned
signal ci_cd_pipeline_activated
signal terraform_state_applied
signal jenkins_build_completed

# Puzzles do nível - Foco em DevOps & Cloud
func initialize_puzzles():
    available_puzzles = [
        {
            "id": "docker_containerization",
            "title": "Containerização Docker",
            "description": "Containerize aplicações com Docker e orquestre serviços",
            "target_moves": 46,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(18, 26),
            "blocks_required": 15,
            "concepts": ["Docker Container", "Dockerfile", "Image Layers", "Container Registry", "Docker Compose", "Volume Management", "Network Bridge", "Port Mapping", "Environment Variables", "Health Checks", "Resource Limits", "Multi-stage Builds", "Security Scanning", "Container Orchestration", "Image Optimization"],
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
            ],
            "docker_features": [
                {"name": "Docker Engine", "version": "24.0", "isolation": "Namespaces"},
                {"name": "Docker Compose", "type": "Service Orchestration", "networks": true},
                {"name": "Registry", "type": "Container Registry", "versioning": "Tag-based"}
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
            "concepts": ["Kubernetes Pod", "Deployment", "Service Discovery", "ConfigMaps", "Secrets", "Persistent Volumes", "StatefulSets", "Ingress", "RBAC", "Helm Charts", "Operators", "Auto-scaling", "Load Balancing", "Node Management", "Cluster Federation", "Service Mesh", "CRDs"],
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
                {"type": "resource_quota", "position": Vector2i(16, 12), "cpu_requests": "90%"},
                {"type": "cluster_network_policy", "position": Vector2i(19, 8), "blocked_paths": 4}
            ],
            "k8s_features": [
                {"name": "Kubernetes Cluster", "nodes": 3, "version": "1.28"},
                {"name": "Service Mesh", "type": "Istio", "features": "mTLS"},
                {"name": "Helm", "type": "Package Manager", "charts": "Official"}
            ]
        },
        {
            "id": "aws_cloud_infrastructure",
            "title": "Infraestrutura AWS Cloud",
            "description": "Provisione recursos cloud na AWS com boas práticas",
            "target_moves": 50,
            "start_position": Vector2i(20, 4),
            "goal_position": Vector2i(36, 28),
            "blocks_required": 19,
            "concepts": ["EC2 Instances", "S3 Storage", "VPC Networking", "RDS Database", "Lambda Functions", "IAM Roles", "Auto Scaling", "Load Balancers", "CloudFront CDN", "Route53 DNS", "CloudWatch", "AWS CLI", "CloudFormation", "Security Groups", "Elastic Container Service", "Serverless", "Edge Computing"],
            "mechanics": {
                "resource_provisioning": true,
                "network_configuration": true,
                "security_implementation": true,
                "monitoring_setup": true,
                "cost_optimization": true,
                "scalability_management": true,
                "backup_strategies": true,
                "disaster_recovery": true
            },
            "obstacles": [
                {"type": "vpc_cidr_conflicts", "position": Vector2i(24, 8), "overlapping_ranges": 2},
                {"type": "security_group_rules", "position": Vector2i(27, 14), "rule_conflicts": 6},
                {"type": "rds_performance", "position": Vector2i(30, 20), "connections": 950},
                {"type": "cloudwatch_costs", "position": Vector2i(33, 26), "over_budget": "150%"}
            ],
            "aws_features": [
                {"name": "AWS Region", "region": "us-west-2", "availability_zones": 3},
                {"name": "VPC", "type": "Network Isolation", "cidr": "10.0.0.0/16"},
                {"name": "RDS", "engine": "PostgreSQL", "version": "15.4"}
            ]
        },
        {
            "id": "cicd_pipeline_automation",
            "title": "Automação CI/CD Pipeline",
            "description": "Construa pipelines de integração e deployment contínuos",
            "target_moves": 52,
            "start_position": Vector2i(6, 30),
            "goal_position": Vector2i(26, 4),
            "blocks_required": 21,
            "concepts": ["GitHub Actions", "GitLab CI", "CircleCI", "Azure DevOps", "Source Control", "Branch Strategy", "Code Review", "Automated Testing", "Build Automation", "Artifact Management", "Environment Promotion", "Rollback Strategies", "Feature Flags", "Blue-Green Deployment", "Canary Releases", "Monitoring Integration", "Security Scanning", "Compliance Checks"],
            "mechanics": {
                "version_control": true,
                "automated_testing": true,
                "build_orchestration": true,
                "artifact_publishing": true,
                "environment_management": true,
                "deployment_automation": true,
                "rollback_capability": true,
                "notification_systems": true
            },
            "obstacles": [
                {"type": "test_duration", "position": Vector2i(10, 26), "test_time_minutes": 45},
                {"type": "build_dependency", "position": Vector2i(14, 20), "circular_deps": 3},
                {"type": "deployment_window", "position": Vector2i(18, 14), "maintenance_hours": "02:00-04:00"},
                {"type": "rollout_strategy", "position": Vector2i(22, 8), "canary_percentage": "1%"}
            ],
            "cicd_features": [
                {"name": "GitHub Actions", "workflows": 12, "triggers": "push/pr"},
                {"name": "Test Coverage", "threshold": "85%", "tools": "Jest/Cypress"},
                {"name": "Deployment", "type": "Rolling", "strategy": "Blue-Green"}
            ]
        },
        {
            "id": "terraform_infrastructure_as_code",
            "title": "Terraform Infrastructure as Code",
            "description": "Gerencie infraestrutura como código com Terraform",
            "target_moves": 54,
            "start_position": Vector2i(28, 8),
            "goal_position": Vector2i(38, 26),
            "blocks_required": 23,
            "concepts": ["Terraform State", "HCL Language", "Provider Configuration", "Resource Blocks", "Variables", "Locals", "Data Sources", "Modules", "Workspace Management", "Remote State", "State Locking", "Plan Execution", "Apply Lifecycle", "Terraform Cloud", "Provider Plugins", "Terraform Registry", "Custom Modules", "Best Practices"],
            "mechanics": {
                "state_management": true,
                "resource_definition": true,
                "dependency_resolution": true,
                "plan_validation": true,
                "apply_execution": true,
                "module_organization": true,
                "workspace_management": true,
                "output_handling": true
            },
            "obstacles": [
                {"type": "state_corruption", "position": Vector2i(30, 12), "corruption_events": 1},
                {"type": "dependency_graph", "position": Vector2i(32, 18), "complexity_level": "high"},
                {"type": "plan_drift", "position": Vector2i(34, 22), "drifted_resources": 8},
                {"type": "module_versioning", "position": Vector2i(36, 24), "version_conflicts": 2}
            ],
            "terraform_features": [
                {"name": "Terraform", "version": "1.6", "state_backend": "S3"},
                {"name": "Providers", "count": 15, "aws": "primary"},
                {"name": "Modules", "count": 8, "organization": "Monorepo"}
            ]
        },
        {
            "id": "jenkins_build_orchestration",
            "title": "Orquestração Jenkins Build",
            "description": "Configure builds complexos com Jenkins e plugins",
            "target_moves": 56,
            "start_position": Vector2i(8, 4),
            "goal_position": Vector2i(34, 30),
            "blocks_required": 25,
            "concepts": ["Jenkins Jobs", "Pipeline DSL", "Jenkinsfile", "Agent Configuration", "Plugin Management", "Build Triggers", "Parameterization", "Post-build Actions", "Pipeline Libraries", "Shared Libraries", "Notification Systems", "Test Automation", "Deployment Pipeline", "Security Configuration", "Backup Strategies", "Performance Tuning", "Plugin Development", "Custom Steps"],
            "mechanics": {
                "pipeline_creation": true,
                "job_configuration": true,
                "trigger_orchestration": true,
                "parameter_handling": true,
                "artifact_management": true,
                "notification_setup": true,
                "security_enforcement": true,
                "performance_optimization": true
            },
            "obstacles": [
                {"type": "jenkins_slave_load", "position": Vector2i(12, 8), "slave_utilization": "95%"},
                {"type": "plugin_incompatibilities", "position": Vector2i(16, 16), "conflicts": 4},
                {"type": "build_queue_backlog", "position": Vector2i(20, 24), "pending_builds": 25},
                {"type": "credential_management", "position": Vector2i(26, 28), "expired_secrets": 3}
            ],
            "jenkins_features": [
                {"name": "Jenkins", "version": "2.426", "agents": 8},
                {"name": "Pipeline", "type": "Declarative", "libraries": 3},
                {"name": "Plugins", "count": 45, "core": "essential"}
            ]
        }
    ]

func _ready():
    _initialize_concept_cache()
    _initialize_object_pool()
    print("🚀 Iniciando Nível 11: A Fábrica Cloud")
    
    # Inicializar sistemas
    game_manager = get_tree().get_first_node_in_group("game_manager")
    drag_system = get_tree().get_first_node_in_group("drag_system")
    player = get_tree().get_first_node_in_group("player")
    ui_manager = get_tree().get_first_node_in_group("ui_manager")
    ability_system = get_tree().get_first_node_in_group("ability_system")
    
    # Verificar referências críticas
    if not game_manager:
        push_error("GameManager não encontrado!")
        return
    if not drag_system:
        push_error("DragAndDropSystem não encontrado!")
        return
    if not player:
        push_error("PlayerController não encontrado!")
        return
    
    # Inicializar dados
    initialize_puzzles()
    setup_level_data()
    setup_ui_elements()
    
    # Configurar sinais
    connect_signals()
    
    # Inicializar primeiro puzzle
    setup_current_puzzle()
    
    current_state = LevelState.PLAYING
    print("✅ Nível 11 inicializado com sucesso!")

func setup_level_data():
    # Configurar posições e elementos iniciais
    start_position = available_puzzles[0].start_position
    goal_position = available_puzzles[0].goal_position
    target_moves = available_puzzles[0].target_moves

func setup_ui_elements():
    # Criar elementos de UI específicos do DevOps
    if ui_manager:
        move_counter = ui_manager.find_child("MoveCounter", true, false)
        timer_label = ui_manager.find_child("TimerLabel", true, false)
        puzzle_info_label = ui_manager.find_child("PuzzleInfoLabel", true, false)
        progress_bar = ui_manager.find_child("ProgressBar", true, false)

func connect_signals():
    # Conectar sinais do sistema
    if game_manager:
        game_manager.connect("level_start", _on_level_start)
        game_manager.connect("move_made", _on_move_made)
        game_manager.connect("block_placed", _on_block_placed)
    
    if drag_system:
        drag_system.connect("block_dropped", _on_block_dropped)
        drag_system.connect("block_removed", _on_block_removed)
    
    # Conectar sinais locais
    self.connect("puzzle_solved", _on_puzzle_solved)
    self.connect("level_completed", _on_level_completed)

func setup_current_puzzle():
    if current_puzzle_index >= available_puzzles.size():
        print("🎉 Todos os puzzles completados!")
        complete_level()
        return
    
    var current_puzzle = available_puzzles[current_puzzle_index]
    var puzzle_data = current_puzzle
    
    # Configurar puzzle atual
    start_position = puzzle_data.start_position
    goal_position = puzzle_data.goal_position
    target_moves = puzzle_data.target_moves
    blocks_placed = 0
    moves_used = 0
    
    # Atualizar UI
    update_puzzle_info(puzzle_data)
    
    # Configurar grid para o puzzle
    if game_manager:
        game_manager.call("setup_puzzle_grid", start_position, goal_position, puzzle_data)
    
    print("🎯 Configurando puzzle: " + str(puzzle_data.title) + "")
    print("📍 Posição inicial: " + str(start_position) + "")
    print("🎯 Posição objetivo: " + str(goal_position) + "")
    print("🎮 Movimentos alvo: " + str(target_moves) + "")

func update_puzzle_info(puzzle_data: Dictionary):
    if puzzle_info_label:
        puzzle_info_label.text = "Puzzle {current_puzzle_index + 1}/6\n{puzzle_data.title}\nObjetivo: " + str(target_moves) + " movimentos"

func _on_level_start():
    print("🚀 Iniciando Nível 11: A Fábrica Cloud")
    is_timer_running = true

func _on_move_made():
    moves_used += 1
    if move_counter:
        move_counter.text = "Movimentos: {moves_used}/" + str(target_moves) + ""
    
    # Verificar se atingiu limite de movimentos
    if moves_used > target_moves and current_state == LevelState.PLAYING:
        print("⚠️ Limite de movimentos atingido!")
        fail_level()
        return
    
    emit_signal("move_made")

func _on_block_placed(block_data: Dictionary):
    blocks_placed += 1
    print("🔧 Bloco colocado: {block_data.type} (Total: " + str(blocks_placed) + ")")

func _on_block_dropped(block_data: Dictionary, position: Vector2i):
    print("📦 Bloco solto: {block_data.type} em " + str(position) + "")

func _on_block_removed(block_data: Dictionary):
    blocks_placed = max(0, blocks_placed - 1)
    print("🗑️ Bloco removido: {block_data.type} (Total: " + str(blocks_placed) + ")")

func _on_puzzle_solved(puzzle_data: Dictionary):
    print("✅ Puzzle resolvido: " + str(puzzle_data.title) + "")
    
    # Emitir sinais específicos baseados no tipo de puzzle
    match puzzle_data.id:
        "docker_containerization":
            emit_signal("docker_container_deployed")
        "kubernetes_orchestration":
            emit_signal("kubernetes_service_deployed")
        "aws_cloud_infrastructure":
            emit_signal("aws_infrastructure_provisioned")
        "cicd_pipeline_automation":
            emit_signal("ci_cd_pipeline_activated")
        "terraform_infrastructure_as_code":
            emit_signal("terraform_state_applied")
        "jenkins_build_orchestration":
            emit_signal("jenkins_build_completed")
    
    # Avançar para próximo puzzle
    current_puzzle_index += 1
    if current_puzzle_index < available_puzzles.size():
        # Pequena pausa antes do próximo puzzle
        await get_tree().create_timer(2.0).timeout
        setup_current_puzzle()
    else:
        # Todos os puzzles completados
        complete_level()

func complete_level():
    print("🎉 Nível 11 'A Fábrica Cloud' completado com sucesso!")
    current_state = LevelState.COMPLETED
    is_timer_running = false
    
    # Calcular estatísticas finais
    var efficiency = float(target_moves) / float(moves_used) * 100.0
    var final_time = level_timer
    
    # Emitir sinal de conclusão
    emit_signal("level_completed", {
        "level_name": level_name,
        "moves_used": moves_used,
        "target_moves": target_moves,
        "efficiency": efficiency,
        "completion_time": final_time,
        "puzzles_completed": available_puzzles.size(),
        "total_puzzles": available_puzzles.size()
    })
    
    # Feedback visual
    if game_manager:
        game_manager.call("show_level_completion", level_name, efficiency, final_time)

func fail_level():
    print("❌ Nível 11 falhou!")
    current_state = LevelState.FAILED
    is_timer_running = false
    
    emit_signal("level_failed", {
        "level_name": level_name,
        "moves_used": moves_used,
        "target_moves": target_moves,
        "reason": "exceeded_move_limit"
    })

func _process(delta):
    if is_timer_running:
        level_timer += delta
        
        if timer_label:
            var minutes = int(level_timer / 60)
            var seconds = int(level_timer) % 60
            timer_label.text = "Tempo: {minutes:02d}:" + str(seconds:02d) + ""

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        if game_manager:
            game_manager.call("show_pause_menu")

func reset_level():
    print("🔄 Reiniciando Nível 11...")
    current_puzzle_index = 0
    moves_used = 0
    blocks_placed = 0
    level_timer = 0.0
    is_timer_running = false
    current_state = LevelState.PLAYING
    
    # Resetar contadores de habilidades
    ability_used_count.clear()
    
    setup_current_puzzle()

func get_puzzle_progress() -> Dictionary:
    return {
        "current_puzzle": current_puzzle_index + 1,
        "total_puzzles": available_puzzles.size(),
        "progress_percentage": float(current_puzzle_index) / float(available_puzzles.size()) * 100.0,
        "current_puzzle_data": available_puzzles[current_puzzle_index] if current_puzzle_index < available_puzzles.size() else null
    }

func get_ability_requirements() -> Array:
    var requirements = []
    
    # Adicionar requisitos baseados no puzzle atual
    if current_puzzle_index < available_puzzles.size():
        var current_puzzle = available_puzzles[current_puzzle_index]
        if current_puzzle.has("mechanics"):
            requirements.append_array(current_puzzle.mechanics.keys())
    
    return requirements

func on_ability_used(ability_name: String):
    if not ability_used_count.has(ability_name):
        ability_used_count[ability_name] = 0
    ability_used_count[ability_name] += 1
    
    emit_signal("ability_activated", ability_name)
    print("⚡ Habilidade utilizada: " + str(ability_name) + "")

func get_performance_metrics() -> Dictionary:
    var efficiency = float(target_moves) / float(max(moves_used, 1)) * 100.0
    
    return {
        "moves_efficiency": efficiency,
        "time_elapsed": level_timer,
        "blocks_efficiency": float(blocks_placed) / float(max(moves_used, 1)),
        "puzzle_progress": get_puzzle_progress(),
        "abilities_used": ability_used_count.duplicate(),
        "devops_score": calculate_devops_score()
    }

func calculate_devops_score() -> float:
    var base_score = 100.0
    var efficiency_penalty = (moves_used - target_moves) * 2.0
    var time_penalty = level_timer * 0.1
    
    return max(0.0, base_score - efficiency_penalty - time_penalty)

func get_level_completion_data() -> Dictionary:
    return {
        "level_name": level_name,
        "level_description": level_description,
        "puzzles_completed": current_puzzle_index,
        "total_puzzles": available_puzzles.size(),
        "completion_percentage": float(current_puzzle_index) / float(available_puzzles.size()) * 100.0,
        "devops_technologies": [
            "Docker Containerization",
            "Kubernetes Orchestration", 
            "AWS Cloud Infrastructure",
            "CI/CD Pipeline Automation",
            "Terraform Infrastructure as Code",
            "Jenkins Build Orchestration"
        ],
        "skill_areas": [
            "Container Management",
            "Service Orchestration",
            "Cloud Provisioning",
            "Pipeline Automation",
            "Infrastructure Management",
            "Build Coordination"
        ]
    }
func _exit_tree():
    print("🧹 Level'${level_num}': Cleanup automático")
    concepts.clear()
    containers.clear()
    deployments.clear()
    services.clear()

func _initialize_concept_cache():
    _initialize_object_pool()
    print("📦 Level'${level_num}': Cache de conceitos inicializado")
    # Cache de conceitos para performance

func _initialize_object_pool():
    for i in _object_pool_size:
        _resource_pool.append({"id": "resource_" + str(i), "status": "available"})
    print("🎯 Level'${level_num}': Object pool inicializado")

func acquire_resource() -> Dictionary:
    return _resource_pool.pop_back() if _resource_pool.size() > 0 else {"id": "new_resource", "status": "created"}

func return_resource(resource: Dictionary):
    resource["status"] = "available"
    _resource_pool.append(resource)
