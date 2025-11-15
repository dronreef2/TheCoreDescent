# THE CORE DESCENT - NÍVEL 5: O ARQUITETO DE SOFTWARE
# Arquivo: Level5.gd - Implementação do nível final com integração completa

extends Node2D
class_name Level5

# Configurações do nível
@export var level_name: String = "O Arquiteto de Software"
@export var level_description: String = "Integre todos os conceitos para criar uma arquitetura de software robusta"
@export var target_moves: int = 25  # Número ideal de movimentos
@export var grid_width: int = 28
@export var grid_height: int = 22

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
var start_position: Vector2i = Vector2i(2, 11)
var goal_position: Vector2i = Vector2i(25, 11)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}  # Contador de uso de habilidades
var architecture_components: Array = []  # Componentes da arquitetura
var tests_passing: int = 0  # Testes que passam
var tests_total: int = 0  # Total de testes
var microservices_deployed: Array = []  # Microservices implantados
var integration_points: Dictionary = {}  # Pontos de integração
var performance_metrics: Dictionary = {}  # Métricas de performance

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_title: Label
var instructions_label: Label
var architecture_counter: Label
var test_counter: Label
var microservices_counter: Label
var performance_label: Label

func _ready():
	setup_level()
	setup_ui()
	load_available_puzzles()
	load_puzzle(0)

func setup_level():
	"""Configuração inicial do nível"""
	# Adicionar ao grupo de níveis
	add_to_group("levels")
	
	# Obter referências dos sistemas
	if get_tree().current_scene.has_method("get_game_manager"):
		game_manager = get_tree().current_scene.get_game_manager()
		drag_system = game_manager.get_drag_system()
		player = game_manager.get_player()
		ui_manager = game_manager.get_ui_manager()
		ability_system = game_manager.get_ability_system()

func setup_ui():
	"""Configura interface do usuário"""
	# Criar container para UI
	var ui_container = Control.new()
	ui_container.name = "UI"
	ui_container.anchor_left = 0
	ui_container.anchor_top = 0
	ui_container.anchor_right = 1
	ui_container.anchor_bottom = 0
	ui_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_container.size_flags_vertical = Control.SIZE_FILL
	add_child(ui_container)
	
	# Título do nível
	puzzle_title = Label.new()
	puzzle_title.text = "PUZZLE FINAL: ARQUITETURA INTEGRADA"
	puzzle_title.position = Vector2(20, 20)
	puzzle_title.modulate = Color(1, 1, 0)  # Dourado para nível final
	ui_container.add_child(puzzle_title)
	
	# Contador de movimentos
	move_counter = Label.new()
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	move_counter.position = Vector2(20, 50)
	ui_container.add_child(move_counter)
	
	# Timer
	timer_label = Label.new()
	timer_label.text = "Tempo: 0.0s"
	timer_label.position = Vector2(20, 80)
	ui_container.add_child(timer_label)
	
	# Contador de arquitetura
	architecture_counter = Label.new()
	architecture_counter.text = "Componentes: 0"
	architecture_counter.position = Vector2(20, 110)
	architecture_counter.modulate = Color(1, 1, 0)
	ui_container.add_child(architecture_counter)
	
	# Contador de testes
	test_counter = Label.new()
	test_counter.text = "Testes: 0/0 ✓"
	test_counter.position = Vector2(20, 140)
	test_counter.modulate = Color(0.2, 1.0, 0.2)  # Verde para testes
	ui_container.add_child(test_counter)
	
	# Contador de microservices
	microservices_counter = Label.new()
	microservices_counter.text = "Microservices: 0"
	microservices_counter.position = Vector2(20, 170)
	microservices_counter.modulate = Color(0.2, 0.8, 1.0)  # Azul claro
	ui_container.add_child(microservices_counter)
	
	# Métricas de performance
	performance_label = Label.new()
	performance_label.text = "Performance: --"
	performance_label.position = Vector2(20, 200)
	performance_label.modulate = Color(1, 0.5, 0)  # Laranja
	ui_container.add_child(performance_label)
	
	# Instruções
	instructions_label = Label.new()
	instructions_label.text = "Use TODAS as linguagens e conceitos para criar uma arquitetura robusta!\nIntegração: Threads + OOP + Padrões + Performance + Testes + Microservices"
	instructions_label.position = Vector2(20, 230)
	instructions_label.size = Vector2(600, 60)
	ui_container.add_child(instructions_label)

func load_available_puzzles():
	"""Carrega puzzles disponíveis para este nível"""
	available_puzzles = [
		{
			"name": "Microservices com Docker",
			"description": "Implmente arquitetura de microservices com containerização",
			"blocks_needed": ["DOCKER", "SERVICE_DISCOVERY", "API_GATEWAY", "MOVE", "MOVE", "MOVE", "MOVE", "MOVE", "LOAD_BALANCER", "CIRCUIT_BREAKER"],
			"start_pos": Vector2i(2, 11),
			"goal_pos": Vector2i(25, 11),
			"special_items": [
				{"type": "docker_container", "name": "UserService", "pos": Vector2i(6, 9), "port": 8080, "image": "user-service:latest"},
				{"type": "docker_container", "name": "OrderService", "pos": Vector2i(6, 11), "port": 8081, "image": "order-service:latest"},
				{"type": "docker_container", "name": "PaymentService", "pos": Vector2i(6, 13), "port": 8082, "image": "payment-service:latest"},
				{"type": "service_registry", "pos": Vector2i(8, 11), "services": ["UserService", "OrderService", "PaymentService"]},
				{"type": "api_gateway", "pos": Vector2i(10, 11), "routes": ["/api/users", "/api/orders", "/api/payments"]},
				{"type": "load_balancer", "pos": Vector2i(12, 11), "algorithm": "round_robin", "targets": 3},
				{"type": "circuit_breaker", "pos": Vector2i(14, 11), "threshold": 50, "timeout": 5000},
				{"type": "message_queue", "pos": Vector2i(16, 11), "type": "rabbitmq", "topics": ["user.created", "order.completed"]},
				{"type": "cache_layer", "pos": Vector2i(18, 11), "type": "redis", "ttl": 300},
				{"type": "gem", "pos": Vector2i(23, 11), "requires_microservices": true}
			],
			"solution_steps": [
				"Criar containers Docker para cada service",
				"Configurar service discovery para registro",
				"Implementar API Gateway como ponto de entrada",
				"Configurar load balancer para distribuição",
				"Adicionar circuit breaker para resiliência",
				"Implementar message queue para comunicação assíncrona",
				"Adicionar cache layer para performance",
				"Coletar gema com arquitetura de microservices completa"
			],
			"hints": [
				"Cada microservice tem responsabilidade única",
				"API Gateway gerencia autenticação e roteamento",
				"Circuit breaker previne falhas em cascata"
			],
			"languages": ["java", "python", "csharp", "javascript"]
		},
		{
			"name": "Test-Driven Development",
			"description": "Implemente testes unitários e integração para garantir qualidade",
			"blocks_needed": ["UNIT_TEST", "INTEGRATION_TEST", "MOCK", "ASSERT", "MOVE", "MOVE", "MOVE", "MOVE", "COVERAGE", "CI_PIPELINE"],
			"start_pos": Vector2i(2, 11),
			"goal_pos": Vector2i(25, 11),
			"special_items": [
				{"type": "test_suite", "name": "UserTests", "pos": Vector2i(6, 9), "tests": ["test_user_creation", "test_user_validation", "test_user_authentication"]},
				{"type": "test_suite", "name": "OrderTests", "pos": Vector2i(6, 11), "tests": ["test_order_creation", "test_order_processing", "test_order_cancellation"]},
				{"type": "test_suite", "name": "PaymentTests", "pos": Vector2i(6, 13), "tests": ["test_payment_processing", "test_refund", "test_payment_validation"]},
				{"type": "mock_service", "pos": Vector2i(8, 10), "mocks": ["ExternalAPI", "Database", "EmailService"]},
				{"type": "test_runner", "pos": Vector2i(10, 11), "framework": "jest/junit"},
				{"type": "coverage_tracker", "pos": Vector2i(12, 11), "target": 90},
				{"type": "ci_pipeline", "pos": Vector2i(14, 11), "stages": ["build", "test", "deploy"]},
				{"type": "performance_test", "pos": Vector2i(16, 11), "load": 1000, "duration": 60},
				{"type": "security_scan", "pos": Vector2i(18, 11), "tools": ["sonarqube", "owasp"]},
				{"type": "gem", "pos": Vector2i(23, 11), "requires_tests": 90}
			],
			"solution_steps": [
				"Escrever testes unitários para cada componente",
				"Criar testes de integração entre services",
				"Usar mocks para dependências externas",
				"Atingir cobertura mínima de 90%",
				"Configurar pipeline CI/CD",
				"Executar testes de performance",
				"Realizar scan de segurança",
				"Coletar gema com 100% de testes passando"
			],
			"hints": [
				"Testes unitários isolam componentes individuais",
				"Testes de integração verificam comunicação entre services",
				"Cobertura não garante qualidade, mas indica pontos não testados"
			],
			"languages": ["java", "python", "csharp", "javascript"]
		},
		{
			"name": "Event-Driven Architecture",
			"description": "Implemente arquitetura orientada a eventos com CQRS e Event Sourcing",
			"blocks_needed": ["EVENT_BUS", "CQRS", "EVENT_SOURCING", "MOVE", "MOVE", "MOVE", "MOVE", "EVENT_STORE", "COMMAND", "QUERY"],
			"start_pos": Vector2i(2, 11),
			"goal_pos": Vector2i(25, 11),
			"special_items": [
				{"type": "event_bus", "pos": Vector2i(6, 10), "topics": ["UserRegistered", "OrderCreated", "PaymentProcessed"]},
				{"type": "command_handler", "pos": Vector2i(8, 9), "commands": ["CreateUser", "CreateOrder", "ProcessPayment"]},
				{"type": "query_handler", "pos": Vector2i(8, 12), "queries": ["GetUserProfile", "GetOrderHistory", "GetAccountBalance"]},
				{"type": "event_store", "pos": Vector2i(10, 11), "storage": "append_only", "retention": "infinite"},
				{"type": "projection_builder", "pos": Vector2i(12, 11), "projections": ["UserProfile", "OrderView", "AccountView"]},
				{"type": "saga_orchestrator", "pos": Vector2i(14, 11), "sagas": ["OrderSaga", "PaymentSaga"]},
				{"type": "event_replay", "pos": Vector2i(16, 11), "from_version": 1, "to_version": "latest"},
				{"type": "read_model_cache", "pos": Vector2i(18, 11), "strategy": "eventual_consistency"},
				{"type": "gem", "pos": Vector2i(23, 11), "requires_cqrs": true}
			],
			"solution_steps": [
				"Configurar event bus para comunicação entre services",
				"Separar comandos (escrita) de consultas (leitura)",
				"Implementar event sourcing para persistir mudanças de estado",
				"Criar projeções para views otimizadas",
				"Orquestrar sagas para transações distribuídas",
				"Implementar replay de eventos para reconstrução",
				"Garantir consistência eventual",
				"Coletar gema com EDA completa"
			],
			"hints": [
				"CQRS separa leitura de escrita para otimização",
				"Event sourcing mantém histórico completo de mudanças",
				"Sagas coordenam transações entre múltiplos services"
			],
			"languages": ["csharp", "java"]
		},
		{
			"name": "Distributed Cache & Session",
			"description": "Implmente sistema distribuído de cache e gerenciamento de sessão",
			"blocks_needed": ["DISTRIBUTED_CACHE", "SESSION_STORE", "MOVE", "MOVE", "MOVE", "MOVE", "REDIS_CLUSTER", "CONSISTENCY", "TTL"],
			"start_pos": Vector2i(2, 11),
			"goal_pos": Vector2i(25, 11),
			"special_items": [
				{"type": "redis_cluster", "pos": Vector2i(6, 10), "nodes": 6, "hash_slots": 16384},
				{"type": "cache_layer", "pos": Vector2i(8, 9), "type": "l2_cache", "size": "1gb"},
				{"type": "session_store", "pos": Vector2i(8, 12), "type": "distributed", "persistence": true},
				{"type": "cache_invalidation", "pos": Vector2i(10, 10), "strategy": "event_based", "topics": ["cache.invalidate"]},
				{"type": "consistency_manager", "pos": Vector2i(12, 11), "level": "eventual", "timeout": 5000},
				{"type": "cache_warmer", "pos": Vector2i(14, 11), "preload": ["user_profiles", "product_catalog"]},
				{"type": "monitoring_dash", "pos": Vector2i(16, 11), "metrics": ["hit_rate", "latency", "memory_usage"]},
				{"type": "failover_config", "pos": Vector2i(18, 11), "strategy": "master_slave", "replication": 2},
				{"type": "gem", "pos": Vector2i(23, 11), "requires_cache_optimization": true}
			],
			"solution_steps": [
				"Configurar cluster Redis com múltiplos nós",
				"Implementar cache distribuído com TTL",
				"Configurar store de sessão escalável",
				"Implementar invalidação baseada em eventos",
				"Garantir consistência eventual",
				"Pre-carregar dados frequentemente acessados",
				"Configurar failover automático",
				"Coletar gema com cache otimizado"
			],
			"hints": [
				"Cache distribuído permite escalabilidade horizontal",
				"TTL previne dados obsoletos no cache",
				"Invalidação baseada em eventos mantém cache fresco"
			],
			"languages": ["python", "java"]
		},
		{
			"name": "DevOps & Monitoring",
			"description": "Implemente práticas DevOps com monitoramento completo",
			"blocks_needed": ["MONITORING", "ALERTING", "LOGGING", "MOVE", "MOVE", "MOVE", "MOVE", "METRICS", "TRACING", "AUTO_SCALING"],
			"start_pos": Vector2i(2, 11),
			"goal_pos": Vector2i(25, 11),
			"special_items": [
				{"type": "monitoring_stack", "pos": Vector2i(6, 10), "tools": ["prometheus", "grafana", "alertmanager"]},
				{"type": "metrics_collector", "pos": Vector2i(8, 9), "metrics": ["cpu", "memory", "request_rate", "error_rate"]},
				{"type": "log_aggregator", "pos": Vector2i(8, 12), "backend": "elasticsearch", "retention": "30d"},
				{"type": "distributed_tracing", "pos": Vector2i(10, 11), "system": "jaeger", "sampling": 0.01},
				{"type": "alerting_rules", "pos": Vector2i(12, 11), "thresholds": {"cpu": 80, "memory": 85, "latency": 1000}},
				{"type": "auto_scaler", "pos": Vector2i(14, 11), "min_instances": 2, "max_instances": 10, "target_cpu": 70},
				{"type": "health_checks", "pos": Vector2i(16, 11), "interval": 30, "timeout": 5000},
				{"type": "deployment_pipeline", "pos": Vector2i(18, 11), "strategy": "blue_green", "rollback": true},
				{"type": "security_monitoring", "pos": Vector2i(20, 11), "tools": ["waf", "ids", "audit_log"]},
				{"type": "gem", "pos": Vector2i(23, 11), "requires_full_monitoring": true}
			],
			"solution_steps": [
				"Configurar stack de monitoramento (Prometheus + Grafana)",
				"Coletar métricas de performance em tempo real",
				"Agregar logs centralizadamente",
				"Implementar tracing distribuído",
				"Configurar alertas baseados em thresholds",
				"Configurar auto-scaling responsivo",
				"Implementar health checks contínuos",
				"Configurar pipeline de deploy seguro",
				"Adicionar monitoramento de segurança",
				"Coletar gema com observabilidade completa"
			],
			"hints": [
				"Monitoramento proativo previne problemas",
				"Traces ajudam a identificar gargalos",
				"Auto-scaling garante performance sob carga"
			],
			"languages": ["java", "python", "csharp", "javascript"]
		}
	]

func load_puzzle(puzzle_index: int):
	"""Carrega puzzle específico"""
	if puzzle_index >= available_puzzles.size():
		complete_level()
		return
	
	current_puzzle_index = puzzle_index
	var puzzle = available_puzzles[puzzle_index]
	
	# Atualizar UI
	puzzle_title.text = "PUZZLE FINAL " + str(puzzle_index + 1) + ": " + puzzle.name
	var hint_text = puzzle.hints[0] if puzzle.hints.size() > 0 else ""
	instructions_label.text = puzzle.description + "\nDica: " + hint_text
	
	# Reset do nível
	reset_level()
	
	# Configurar posições
	start_position = puzzle.start_pos
	goal_position = puzzle.goal_pos
	
	# Criar elementos especiais
	create_special_items(puzzle.special_items)
	
	# Criar blocos iniciais
	create_initial_blocks(puzzle.blocks_needed)
	
	# Posicionar jogador
	position_player_at_start()
	
	# Iniciar estado
	current_state = LevelState.PLAYING
	is_timer_running = true
	
	emit_signal("puzzle_loaded", puzzle_index)

func reset_level():
	"""Reseta estado do nível"""
	# Limpar blocos existentes
	clear_all_blocks()
	
	# Limpar componentes da arquitetura
	for component in architecture_components:
		if is_instance_valid(component):
			component.queue_free()
	architecture_components.clear()
	microservices_deployed.clear()
	integration_points.clear()
	performance_metrics.clear()
	tests_passing = 0
	tests_total = 0
	
	# Reset contadores
	moves_used = 0
	blocks_placed = 0
	level_timer = 0.0
	ability_used_count.clear()
	
	# Atualizar UI
	move_counter.text = "Movimentos: 0/" + str(target_moves)
	timer_label.text = "Tempo: 0.0s"
	update_counters()

func clear_all_blocks():
	"""Remove todos os blocos do nível"""
	var blocks = get_tree().get_nodes_in_group("logic_blocks")
	for block in blocks:
		block.queue_free()

func update_counters():
	"""Atualiza todos os contadores"""
	architecture_counter.text = "Componentes: " + str(architecture_components.size())
	test_counter.text = "Testes: " + str(tests_passing) + "/" + str(tests_total) + " ✓"
	microservices_counter.text = "Microservices: " + str(microservices_deployed.size())
	
	# Calcular performance geral
	var avg_performance = 0.0
	if performance_metrics.size() > 0:
		var total = 0.0
		for metric in performance_metrics.values():
			total += float(metric)
		avg_performance = total / performance_metrics.size()
	
	performance_label.text = "Performance: " + str(int(avg_performance)) + "/100"

func create_special_items(items: Array):
	"""Cria itens especiais específicos do nível final"""
	for item in items:
		match item.type:
			"docker_container":
				create_docker_container(item.name, item.pos, item.port, item.image)
			"service_registry":
				create_service_registry(item.pos, item.services)
			"api_gateway":
				create_api_gateway(item.pos, item.routes)
			"load_balancer":
				create_load_balancer(item.pos, item.algorithm, item.targets)
			"circuit_breaker":
				create_circuit_breaker(item.pos, item.threshold, item.timeout)
			"message_queue":
				create_message_queue(item.pos, item.type, item.topics)
			"cache_layer":
				create_cache_layer(item.pos, item.type, item.ttl)
			"test_suite":
				create_test_suite(item.name, item.pos, item.tests)
			"mock_service":
				create_mock_service(item.pos, item.mocks)
			"test_runner":
				create_test_runner(item.pos, item.framework)
			"coverage_tracker":
				create_coverage_tracker(item.pos, item.target)
			"ci_pipeline":
				create_ci_pipeline(item.pos, item.stages)
			"performance_test":
				create_performance_test(item.pos, item.load, item.duration)
			"security_scan":
				create_security_scan(item.pos, item.tools)
			"event_bus":
				create_event_bus(item.pos, item.topics)
			"command_handler":
				create_command_handler(item.pos, item.commands)
			"query_handler":
				create_query_handler(item.pos, item.queries)
			"event_store":
				create_event_store(item.pos, item.storage, item.retention)
			"projection_builder":
				create_projection_builder(item.pos, item.projections)
			"saga_orchestrator":
				create_saga_orchestrator(item.pos, item.sagas)
			"event_replay":
				create_event_replay(item.pos, item.from_version, item.to_version)
			"read_model_cache":
				create_read_model_cache(item.pos, item.strategy)
			"redis_cluster":
				create_redis_cluster(item.pos, item.nodes, item.hash_slots)
			"cache_invalidation":
				create_cache_invalidation(item.pos, item.strategy, item.topics)
			"consistency_manager":
				create_consistency_manager(item.pos, item.level, item.timeout)
			"cache_warmer":
				create_cache_warmer(item.pos, item.preload)
			"monitoring_dash":
				create_monitoring_dashboard(item.pos, item.metrics)
			"failover_config":
				create_failover_config(item.pos, item.strategy, item.replication)
			"monitoring_stack":
				create_monitoring_stack(item.pos, item.tools)
			"metrics_collector":
				create_metrics_collector(item.pos, item.metrics)
			"log_aggregator":
				create_log_aggregator(item.pos, item.backend, item.retention)
			"distributed_tracing":
				create_distributed_tracing(item.pos, item.system, item.sampling)
			"alerting_rules":
				create_alerting_rules(item.pos, item.thresholds)
			"auto_scaler":
				create_auto_scaler(item.pos, item.min_instances, item.max_instances, item.target_cpu)
			"health_checks":
				create_health_checks(item.pos, item.interval, item.timeout)
			"deployment_pipeline":
				create_deployment_pipeline(item.pos, item.strategy, item.rollback)
			"security_monitoring":
				create_security_monitoring(item.pos, item.tools)
			"gem":
				create_final_gem(item.pos, get_final_requirements(item))

# Implementações detalhadas dos componentes (versões resumidas para brevidade)
func create_docker_container(name: String, grid_pos: Vector2i, port: int, image: String):
	"""Cria container Docker"""
	var container = Node2D.new()
	container.name = "DockerContainer_" + name
	container.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	container.service_name = name
	container.port = port
	container.image = image
	container.is_running = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/docker_container.png")
	sprite.modulate = Color(0.2, 0.6, 1.0)
	container.add_child(sprite)
	
	# Label do service
	var name_label = Label.new()
	name_label.text = name
	name_label.position = Vector2(-25, -20)
	name_label.modulate = Color.WHITE
	container.add_child(name_label)
	
	add_child(container)
	architecture_components.append(container)

func create_service_registry(grid_pos: Vector2i, services: Array):
	"""Cria service registry"""
	var registry = Node2D.new()
	registry.name = "ServiceRegistry"
	registry.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	registry.services = services.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/service_registry.png")
	sprite.modulate = Color(1, 1, 0)  # Amarelo
	registry.add_child(sprite)
	
	add_child(registry)
	architecture_components.append(registry)

func create_api_gateway(grid_pos: Vector2i, routes: Array):
	"""Cria API Gateway"""
	var gateway = Node2D.new()
	gateway.name = "APIGateway"
	gateway.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gateway.routes = routes.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/api_gateway.png")
	sprite.modulate = Color(0.5, 0.5, 1.0)
	gateway.add_child(sprite)
	
	add_child(gateway)
	architecture_components.append(gateway)

func create_load_balancer(grid_pos: Vector2i, algorithm: String, targets: int):
	"""Cria load balancer"""
	var lb = Node2D.new()
	lb.name = "LoadBalancer"
	lb.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	lb.algorithm = algorithm
	lb.targets = targets
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/load_balancer.png")
	sprite.modulate = Color(0.8, 0.4, 0.8)
	lb.add_child(sprite)
	
	add_child(lb)
	architecture_components.append(lb)

func create_circuit_breaker(grid_pos: Vector2i, threshold: int, timeout: int):
	"""Cria circuit breaker"""
	var cb = Node2D.new()
	cb.name = "CircuitBreaker"
	cb.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	cb.threshold = threshold
	cb.timeout = timeout
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/circuit_breaker.png")
	sprite.modulate = Color.RED
	cb.add_child(sprite)
	
	add_child(cb)
	architecture_components.append(cb)

func create_message_queue(grid_pos: Vector2i, type: String, topics: Array):
	"""Cria message queue"""
	var mq = Node2D.new()
	mq.name = "MessageQueue"
	mq.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	mq.type = type
	mq.topics = topics.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/message_queue.png")
	sprite.modulate = Color(0.2, 0.8, 0.2)
	mq.add_child(sprite)
	
	add_child(mq)
	architecture_components.append(mq)

func create_cache_layer(grid_pos: Vector2i, type: String, ttl: int):
	"""Cria cache layer"""
	var cache = Node2D.new()
	cache.name = "CacheLayer"
	cache.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	cache.type = type
	cache.ttl = ttl
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/cache_layer.png")
	sprite.modulate = Color(1, 0.5, 0)
	cache.add_child(sprite)
	
	add_child(cache)
	architecture_components.append(cache)

# Implementações similares para outros componentes...
func create_test_suite(name: String, grid_pos: Vector2i, tests: Array):
	"""Cria suite de testes"""
	var suite = Node2D.new()
	suite.name = "TestSuite_" + name
	suite.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	suite.test_name = name
	suite.tests = tests.duplicate()
	suite.passing = 0
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/test_suite.png")
	sprite.modulate = Color(0.2, 1.0, 0.2)
	suite.add_child(sprite)
	
	# Progresso dos testes
	var progress_bar = ColorRect.new()
	progress_bar.size = Vector2(30, 3)
	progress_bar.position = Vector2(-15, 15)
	progress_bar.modulate = Color.GREEN
	suite.add_child(progress_bar)
	
	add_child(suite)
	architecture_components.append(suite)
	
	# Atualizar contadores de teste
	tests_total += tests.size()
	update_counters()

func create_mock_service(grid_pos: Vector2i, mocks: Array):
	"""Cria serviço mock"""
	var mock = Node2D.new()
	mock.name = "MockService"
	mock.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	mock.mocks = mocks.duplicate()
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/mock_service.png")
	sprite.modulate = Color(1, 1, 0)
	mock.add_child(sprite)
	
	add_child(mock)
	architecture_components.append(mock)

func create_test_runner(grid_pos: Vector2i, framework: String):
	"""Cria test runner"""
	var runner = Node2D.new()
	runner.name = "TestRunner"
	runner.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	runner.framework = framework
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/test_runner.png")
	sprite.modulate = Color(0.5, 1.0, 0.5)
	runner.add_child(sprite)
	
	add_child(runner)
	architecture_components.append(runner)

func create_coverage_tracker(grid_pos: Vector2i, target: int):
	"""Cria tracker de cobertura"""
	var tracker = Node2D.new()
	tracker.name = "CoverageTracker"
	tracker.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	tracker.target_percent = target
	tracker.current_percent = 0
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/coverage_tracker.png")
	sprite.modulate = Color(0.8, 0.8, 0.2)
	tracker.add_child(sprite)
	
	add_child(tracker)
	architecture_components.append(tracker)

func create_ci_pipeline(grid_pos: Vector2i, stages: Array):
	"""Cria pipeline CI/CD"""
	var pipeline = Node2D.new()
	pipeline.name = "CIPipeline"
	pipeline.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	pipeline.stages = stages.duplicate()
	pipeline.current_stage = 0
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/ci_pipeline.png")
	sprite.modulate = Color(0.4, 0.8, 1.0)
	pipeline.add_child(sprite)
	
	add_child(pipeline)
	architecture_components.append(pipeline)

func create_performance_test(grid_pos: Vector2i, load: int, duration: int):
	"""Cria teste de performance"""
	var perf_test = Node2D.new()
	perf_test.name = "PerformanceTest"
	perf_test.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	perf_test.load = load
	perf_test.duration = duration
	perf_test.is_running = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/performance_test.png")
	sprite.modulate = Color(1, 0.5, 0)
	perf_test.add_child(sprite)
	
	add_child(perf_test)
	architecture_components.append(perf_test)

func create_security_scan(grid_pos: Vector2i, tools: Array):
	"""Cria scan de segurança"""
	var scan = Node2D.new()
	scan.name = "SecurityScan"
	scan.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	scan.tools = tools.duplicate()
	scan.vulnerabilities = 0
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/security_scan.png")
	sprite.modulate = Color(1, 0, 0)
	scan.add_child(sprite)
	
	add_child(scan)
	architecture_components.append(scan)

# Implementações simplificadas para outros componentes
func create_event_bus(grid_pos: Vector2i, topics: Array):
	var event_bus = Node2D.new()
	event_bus.name = "EventBus"
	event_bus.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	event_bus.topics = topics.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/event_bus.png")
	sprite.modulate = Color(0.6, 0.2, 0.8)
	event_bus.add_child(sprite)
	add_child(event_bus)
	architecture_components.append(event_bus)

func create_command_handler(grid_pos: Vector2i, commands: Array):
	var handler = Node2D.new()
	handler.name = "CommandHandler"
	handler.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	handler.commands = commands.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/command_handler.png")
	sprite.modulate = Color(0.7, 0.3, 0.9)
	handler.add_child(sprite)
	add_child(handler)
	architecture_components.append(handler)

func create_query_handler(grid_pos: Vector2i, queries: Array):
	var handler = Node2D.new()
	handler.name = "QueryHandler"
	handler.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	handler.queries = queries.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/query_handler.png")
	sprite.modulate = Color(0.5, 0.7, 1.0)
	handler.add_child(sprite)
	add_child(handler)
	architecture_components.append(handler)

func create_event_store(grid_pos: Vector2i, storage: String, retention: String):
	var store = Node2D.new()
	store.name = "EventStore"
	store.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	store.storage_type = storage
	store.retention = retention
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/event_store.png")
	sprite.modulate = Color(0.8, 0.4, 0.8)
	store.add_child(sprite)
	add_child(store)
	architecture_components.append(store)

func create_projection_builder(grid_pos: Vector2i, projections: Array):
	var builder = Node2D.new()
	builder.name = "ProjectionBuilder"
	builder.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	builder.projections = projections.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/projection_builder.png")
	sprite.modulate = Color(0.6, 0.6, 1.0)
	builder.add_child(sprite)
	add_child(builder)
	architecture_components.append(builder)

func create_saga_orchestrator(grid_pos: Vector2i, sagas: Array):
	var orchestrator = Node2D.new()
	orchestrator.name = "SagaOrchestrator"
	orchestrator.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	orchestrator.sagas = sagas.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/saga_orchestrator.png")
	sprite.modulate = Color(0.9, 0.5, 0.9)
	orchestrator.add_child(sprite)
	add_child(orchestrator)
	architecture_components.append(orchestrator)

func create_event_replay(grid_pos: Vector2i, from_version: int, to_version: String):
	var replay = Node2D.new()
	replay.name = "EventReplay"
	replay.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	replay.from_version = from_version
	replay.to_version = to_version
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/event_replay.png")
	sprite.modulate = Color(0.7, 0.7, 0.9)
	replay.add_child(sprite)
	add_child(replay)
	architecture_components.append(replay)

func create_read_model_cache(grid_pos: Vector2i, strategy: String):
	var cache = Node2D.new()
	cache.name = "ReadModelCache"
	cache.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	cache.strategy = strategy
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/read_model_cache.png")
	sprite.modulate = Color(0.8, 0.6, 0.9)
	cache.add_child(sprite)
	add_child(cache)
	architecture_components.append(cache)

func create_redis_cluster(grid_pos: Vector2i, nodes: int, hash_slots: int):
	var cluster = Node2D.new()
	cluster.name = "RedisCluster"
	cluster.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	cluster.nodes = nodes
	cluster.hash_slots = hash_slots
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/redis_cluster.png")
	sprite.modulate = Color(1, 0.3, 0.3)
	cluster.add_child(sprite)
	add_child(cluster)
	architecture_components.append(cluster)

func create_cache_invalidation(grid_pos: Vector2i, strategy: String, topics: Array):
	var invalidation = Node2D.new()
	invalidation.name = "CacheInvalidation"
	invalidation.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	invalidation.strategy = strategy
	invalidation.topics = topics.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/cache_invalidation.png")
	sprite.modulate = Color(1, 0.6, 0.3)
	invalidation.add_child(sprite)
	add_child(invalidation)
	architecture_components.append(invalidation)

func create_consistency_manager(grid_pos: Vector2i, level: String, timeout: int):
	var manager = Node2D.new()
	manager.name = "ConsistencyManager"
	manager.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	manager.consistency_level = level
	manager.timeout = timeout
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/consistency_manager.png")
	sprite.modulate = Color(0.5, 0.8, 0.5)
	manager.add_child(sprite)
	add_child(manager)
	architecture_components.append(manager)

func create_cache_warmer(grid_pos: Vector2i, preload: Array):
	var warmer = Node2D.new()
	warmer.name = "CacheWarmer"
	warmer.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	warmer.preload_data = preload.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/cache_warmer.png")
	sprite.modulate = Color(0.9, 0.7, 0.4)
	warmer.add_child(sprite)
	add_child(warmer)
	architecture_components.append(warmer)

func create_monitoring_dashboard(grid_pos: Vector2i, metrics: Array):
	var dashboard = Node2D.new()
	dashboard.name = "MonitoringDashboard"
	dashboard.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	dashboard.metrics = metrics.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/monitoring_dash.png")
	sprite.modulate = Color(0.3, 0.9, 0.9)
	dashboard.add_child(sprite)
	add_child(dashboard)
	architecture_components.append(dashboard)

func create_failover_config(grid_pos: Vector2i, strategy: String, replication: int):
	var failover = Node2D.new()
	failover.name = "FailoverConfig"
	failover.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	failover.strategy = strategy
	failover.replication_factor = replication
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/failover_config.png")
	sprite.modulate = Color(0.8, 0.3, 0.3)
	failover.add_child(sprite)
	add_child(failover)
	architecture_components.append(failover)

func create_monitoring_stack(grid_pos: Vector2i, tools: Array):
	var stack = Node2D.new()
	stack.name = "MonitoringStack"
	stack.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	stack.tools = tools.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/monitoring_stack.png")
	sprite.modulate = Color(0.4, 0.8, 0.8)
	stack.add_child(sprite)
	add_child(stack)
	architecture_components.append(stack)

func create_metrics_collector(grid_pos: Vector2i, metrics: Array):
	var collector = Node2D.new()
	collector.name = "MetricsCollector"
	collector.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	collector.metrics = metrics.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/metrics_collector.png")
	sprite.modulate = Color(0.6, 0.9, 0.9)
	collector.add_child(sprite)
	add_child(collector)
	architecture_components.append(collector)

func create_log_aggregator(grid_pos: Vector2i, backend: String, retention: String):
	var aggregator = Node2D.new()
	aggregator.name = "LogAggregator"
	aggregator.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	aggregator.backend = backend
	aggregator.retention = retention
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/log_aggregator.png")
	sprite.modulate = Color(0.5, 0.8, 0.8)
	aggregator.add_child(sprite)
	add_child(aggregator)
	architecture_components.append(aggregator)

func create_distributed_tracing(grid_pos: Vector2i, system: String, sampling: float):
	var tracing = Node2D.new()
	tracing.name = "DistributedTracing"
	tracing.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	tracing.system = system
	tracing.sampling_rate = sampling
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/distributed_tracing.png")
	sprite.modulate = Color(0.7, 0.9, 0.9)
	tracing.add_child(sprite)
	add_child(tracing)
	architecture_components.append(tracing)

func create_alerting_rules(grid_pos: Vector2i, thresholds: Dictionary):
	var rules = Node2D.new()
	rules.name = "AlertingRules"
	rules.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	rules.thresholds = thresholds.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/alerting_rules.png")
	sprite.modulate = Color(0.8, 0.4, 0.4)
	rules.add_child(sprite)
	add_child(rules)
	architecture_components.append(rules)

func create_auto_scaler(grid_pos: Vector2i, min_instances: int, max_instances: int, target_cpu: int):
	var scaler = Node2D.new()
	scaler.name = "AutoScaler"
	scaler.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	scaler.min_instances = min_instances
	scaler.max_instances = max_instances
	scaler.target_cpu = target_cpu
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/auto_scaler.png")
	sprite.modulate = Color(0.6, 0.6, 0.9)
	scaler.add_child(sprite)
	add_child(scaler)
	architecture_components.append(scaler)

func create_health_checks(grid_pos: Vector2i, interval: int, timeout: int):
	var checks = Node2D.new()
	checks.name = "HealthChecks"
	checks.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	checks.interval = interval
	checks.timeout = timeout
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/health_checks.png")
	sprite.modulate = Color(0.5, 0.7, 0.8)
	checks.add_child(sprite)
	add_child(checks)
	architecture_components.append(checks)

func create_deployment_pipeline(grid_pos: Vector2i, strategy: String, rollback: bool):
	var pipeline = Node2D.new()
	pipeline.name = "DeploymentPipeline"
	pipeline.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	pipeline.strategy = strategy
	pipeline.supports_rollback = rollback
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/deployment_pipeline.png")
	sprite.modulate = Color(0.7, 0.5, 0.8)
	pipeline.add_child(sprite)
	add_child(pipeline)
	architecture_components.append(pipeline)

func create_security_monitoring(grid_pos: Vector2i, tools: Array):
	var security = Node2D.new()
	security.name = "SecurityMonitoring"
	security.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	security.tools = tools.duplicate()
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/security_monitoring.png")
	sprite.modulate = Color(1.0, 0.2, 0.2)
	security.add_child(sprite)
	add_child(security)
	architecture_components.append(security)

func get_final_requirements(item: Dictionary) -> Dictionary:
	"""Extrai requisitos da gema final"""
	return {
		"requires_microservices": item.get("requires_microservices", false),
		"requires_tests": item.get("requires_tests", 0),
		"requires_cqrs": item.get("requires_cqrs", false),
		"requires_cache_optimization": item.get("requires_cache_optimization", false),
		"requires_full_monitoring": item.get("requires_full_monitoring", false)
	}

func create_final_gem(grid_pos: Vector2i, requirements: Dictionary):
	"""Cria gema final com requisitos complexos"""
	var gem = Node2D.new()
	gem.name = "FinalGem"
	gem.position = Vector2(grid_pos.x * 32, grid_pos.y * 32)
	gem.requirements = requirements
	gem.is_collected = false
	gem.requirements_met = false
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/items/final_gem.png")
	sprite.modulate = Color.GOLD  # Dourado para gema final
	gem.add_child(sprite)
	
	# Efeito de brilho
	var glow = Sprite2D.new()
	glow.texture = load("res://assets/items/gem_glow.png")
	glow.modulate = Color(1, 1, 0, 0.5)
	gem.add_child(glow)
	
	# Área de colisão
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 15
	collision.shape = shape
	area.add_child(collision)
	area.connect("body_entered", Callable(self, "_on_final_gem_collected"))
	gem.add_child(area)
	
	add_child(gem)

func create_initial_blocks(blocks_needed: Array):
	"""Cria blocos iniciais disponíveis para o jogador"""
	var palette_position = Vector2(50, 330)
	
	var block_spawners = {
		"IF": LogicBlock.BlockType.IF,
		"ELSE": LogicBlock.BlockType.ELSE,
		"FOR": LogicBlock.BlockType.FOR,
		"WHILE": LogicBlock.BlockType.WHILE,
		"VARIABLE": LogicBlock.BlockType.VARIABLE,
		"MOVE": LogicBlock.BlockType.MOVE,
		"ASSIGN": LogicBlock.BlockType.ASSIGN,
		# Blocks avançados de todos os níveis
		"DOCKER": LogicBlock.BlockType.DOCKER,
		"SERVICE_DISCOVERY": LogicBlock.BlockType.SERVICE_DISCOVERY,
		"API_GATEWAY": LogicBlock.BlockType.API_GATEWAY,
		"LOAD_BALANCER": LogicBlock.BlockType.LOAD_BALANCER,
		"CIRCUIT_BREAKER": LogicBlock.BlockType.CIRCUIT_BREAKER,
		"UNIT_TEST": LogicBlock.BlockType.UNIT_TEST,
		"INTEGRATION_TEST": LogicBlock.BlockType.INTEGRATION_TEST,
		"MOCK": LogicBlock.BlockType.MOCK,
		"ASSERT": LogicBlock.BlockType.ASSERT,
		"COVERAGE": LogicBlock.BlockType.COVERAGE,
		"CI_PIPELINE": LogicBlock.BlockType.CI_PIPELINE,
		"EVENT_BUS": LogicBlock.BlockType.EVENT_BUS,
		"CQRS": LogicBlock.BlockType.CQRS,
		"EVENT_SOURCING": LogicBlock.BlockType.EVENT_SOURCING,
		"EVENT_STORE": LogicBlock.BlockType.EVENT_STORE,
		"COMMAND": LogicBlock.BlockType.COMMAND,
		"QUERY": LogicBlock.BlockType.QUERY,
		"DISTRIBUTED_CACHE": LogicBlock.BlockType.DISTRIBUTED_CACHE,
		"SESSION_STORE": LogicBlock.BlockType.SESSION_STORE,
		"REDIS_CLUSTER": LogicBlock.BlockType.REDIS_CLUSTER,
		"CONSISTENCY": LogicBlock.BlockType.CONSISTENCY,
		"TTL": LogicBlock.BlockType.TTL,
		"MONITORING": LogicBlock.BlockType.MONITORING,
		"ALERTING": LogicBlock.BlockType.ALERTING,
		"LOGGING": LogicBlock.BlockType.LOGGING,
		"METRICS": LogicBlock.BlockType.METRICS,
		"TRACING": LogicBlock.BlockType.TRACING,
		"AUTO_SCALING": LogicBlock.BlockType.AUTO_SCALING
	}
	
	var x_offset = 0
	for block_type_name in blocks_needed:
		if block_spawners.has(block_type_name):
			var block_type = block_spawners[block_type_name]
			var block = create_spawner_block(block_type, palette_position + Vector2(x_offset, 0))
			x_offset += 70

func create_spawner_block(block_type: LogicBlock.BlockType, position: Vector2) -> LogicBlock:
	"""Cria bloco no spawner (paleta)"""
	var block = LogicBlock.new()
	block.block_type = block_type
	block.position = position
	block.is_spawner = true
	block.z_index = 10
	
	add_child(block)
	block.add_to_group("logic_blocks")
	
	return block

func position_player_at_start():
	"""Posiciona jogador no início do nível"""
	if player:
		var start_world_pos = Vector2(start_position.x * 32, start_position.y * 32)
		player.global_position = start_world_pos

func _process(delta):
	"""Processa lógica do nível"""
	if is_timer_running:
		level_timer += delta
		timer_label.text = "Tempo: " + str(round(level_timer * 10) / 10) + "s"
	
	# Atualizar contadores periodicamente
	if int(level_timer * 2) % 1 == 0:  # A cada 0.5s
		update_counters()
		simulate_architecture_progress()
	
	# Verificar condições de vitória/derrota
	check_level_completion()

func simulate_architecture_progress():
	"""Simula progresso da arquitetura em tempo real"""
	# Simular testes passando
	if architecture_components.size() > 0 and tests_passing < tests_total:
		tests_passing = min(tests_total, tests_passing + randi() % 3)
	
	# Simular deployment de microservices
	if architecture_components.size() > 5 and microservices_deployed.size() < 3:
		microservices_deployed.append("Service_" + str(microservices_deployed.size() + 1))
	
	# Simular métricas de performance
	var base_performance = 50 + (architecture_components.size() * 5) + (tests_passing * 0.5)
	performance_metrics["overall"] = min(100, base_performance)
	performance_metrics["availability"] = 95 + randi() % 5
	performance_metrics["latency"] = max(50, 100 - (architecture_components.size() * 2))
	performance_metrics["throughput"] = 60 + (microservices_deployed.size() * 10)

func check_level_completion():
	"""Verifica se nível foi completado"""
	if current_state != LevelState.PLAYING:
		return
	
	# Verificar se jogador chegou ao objetivo
	if player and player.global_position.distance_to(Vector2(goal_position.x * 32, goal_position.y * 32)) < 20:
		complete_current_puzzle()

func complete_current_puzzle():
	"""Completa puzzle atual e avança para próximo"""
	current_state = LevelState.COMPLETED
	is_timer_running = false
	
	# Calcular pontuação final (todos os conceitos)
	var score = calculate_final_score()
	
	# Mostrar resultado
	show_puzzle_completion(score)
	
	# Aguardar antes de carregar próximo puzzle
	await get_tree().create_timer(3.0).timeout
	
	load_puzzle(current_puzzle_index + 1)

func calculate_final_score() -> Dictionary:
	"""Calcula pontuação final baseada em todos os conceitos"""
	var time_score = max(0, 100 - int(level_timer))
	var moves_score = max(0, 100 - (moves_used * 3))
	var efficiency_score = blocks_placed > 0 ? 100 - (abs(blocks_placed - target_moves) * 2) : 50
	var architecture_score = calculate_architecture_score()
	var test_score = calculate_test_score()
	var performance_score = performance_metrics.get("overall", 0)
	var integration_score = calculate_integration_score()
	
	return {
		"time": time_score,
		"moves": moves_score,
		"efficiency": efficiency_score,
		"architecture": architecture_score,
		"test_quality": test_score,
		"performance": performance_score,
		"integration": integration_score,
		"total": (time_score + moves_score + efficiency_score + architecture_score + test_score + performance_score + integration_score) / 7
	}

func calculate_architecture_score() -> int:
	"""Calcula pontuação baseada na arquitetura"""
	var arch_score = 20  # Base score
	
	# Bonus por componentes implementados
	arch_score += min(40, architecture_components.size() * 3)
	
	# Bonus por microservices
	arch_score += min(20, microservices_deployed.size() * 6)
	
	# Bonus por variedade de componentes
	var component_types = {}
	for component in architecture_components:
		var type = component.name.split("_")[0]
		component_types[type] = true
	
	if component_types.size() >= 5:
		arch_score += 20
	elif component_types.size() >= 3:
		arch_score += 10
	
	return min(100, arch_score)

func calculate_test_score() -> int:
	"""Calcula pontuação baseada em testes"""
	var test_score = 0
	
	if tests_total > 0:
		var pass_rate = float(tests_passing) / float(tests_total)
		test_score = int(pass_rate * 100)
	
	return test_score

func calculate_integration_score() -> int:
	"""Calcula pontuação baseada em integração"""
	var integration_score = 30  # Base score
	
	# Bonus por pontos de integração
	integration_score += min(40, integration_points.size() * 10)
	
	# Bonus por conceitos de diferentes linguagens
	var languages_used = ability_used_count.keys()
	if languages_used.size() >= 4:
		integration_score += 30
	elif languages_used.size() >= 2:
		integration_score += 15
	
	return min(100, integration_score)

func show_puzzle_completion(score: Dictionary):
	"""Mostra tela de completion do puzzle"""
	var completion_panel = Control.new()
	completion_panel.name = "CompletionPanel"
	completion_panel.anchor_left = 0.3
	completion_panel.anchor_top = 0.3
	completion_panel.anchor_right = 0.7
	completion_panel.anchor_bottom = 0.7
	completion_panel.modulate = Color.BLACK.with_alpha(0.9)
	add_child(completion_panel)
	
	# Título
	var title = Label.new()
	title.text = "ARQUITETURA FINAL COMPLETADA!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -50)
	title.modulate = Color(1, 1, 0)  # Dourado
	completion_panel.add_child(title)
	
	# Pontuação
	var score_text = Label.new()
	score_text.text = "PONTUAÇÃO FINAL: " + str(int(score.total))
	score_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_text.position = Vector2(0, -10)
	score_text.modulate = Color.GOLD
	completion_panel.add_child(score_text)
	
	# Detalhes
	var details = Label.new()
	details.text = "Arquitetura: " + str(int(score.architecture)) + " | Testes: " + str(int(score.test_quality)) + "\nPerformance: " + str(int(score.performance)) + " | Integração: " + str(int(score.integration))
	details.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	details.position = Vector2(0, 20)
	completion_panel.add_child(details)

func complete_level():
	"""Completa todo o nível - FIM DO JOGO"""
	current_state = LevelState.COMPLETED
	is_timer_running = false
	
	emit_signal("level_completed", current_puzzle_index)
	
	# Mostrar tela final do jogo
	show_game_completion()

func show_game_completion():
	"""Mostra completion screen final do jogo"""
	var final_panel = Control.new()
	final_panel.name = "GameCompletePanel"
	final_panel.anchor_left = 0.1
	final_panel.anchor_top = 0.1
	final_panel.anchor_right = 0.9
	final_panel.anchor_bottom = 0.9
	final_panel.modulate = Color(0, 0, 0, 0.95)
	add_child(final_panel)
	
	# Título principal
	var title = Label.new()
	title.text = "PARABÉNS! VOCÊ É UM ARQUITETO DE SOFTWARE!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.position = Vector2(0, -120)
	title.modulate = Color.GOLD
	title.scale = Vector2(1.2, 1.2)
	final_panel.add_child(title)
	
	# Conquistas
	var achievements = Label.new()
	achievements.text = "🏆 CONQUISTAS DESBLOQUEADAS:\n" + \
		"✓ Mestre de C++ (Ponteiros e Gerenciamento de Memória)\n" + \
		"✓ Especialista em Java/Python (OOP e Duck Typing)\n" + \
		"✓ Expert em C#/JavaScript (Concorrência e Async)\n" + \
		"✓ Arquiteto de Microservices\n" + \
		"✓ DevOps Engineer (CI/CD e Monitoring)\n" + \
		"✓ Expert em Padrões de Design\n" + \
		"✓ Especialista em Test-Driven Development"
	achievements.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	achievements.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	achievements.position = Vector2(0, -20)
	achievements.modulate = Color(0.9, 0.9, 0.9)
	final_panel.add_child(achievements)
	
	# Mensagem final
	var final_message = Label.new()
	final_message.text = "Você dominou todos os conceitos fundamentais de programação!\n" + \
		"Está pronto para desenvolver software de alta qualidade\n" + \
		"usando as melhores práticas e tecnologias modernas."
	final_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	final_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	final_message.position = Vector2(0, 60)
	final_message.modulate = Color(0.8, 0.8, 1.0)
	final_panel.add_child(final_message)
	
	# Estatísticas finais
	var stats = Label.new()
	stats.text = "Estatísticas da Jornada:\n" + \
		"Níveis Completados: 5/5\n" + \
		"Conceitos Dominados: 50+\n" + \
		"Linguagens de Programação: 4\n" + \
		"Padrões de Design: 15+\n" + \
		"Tempo Total: " + str(int(level_timer)) + "s"
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stats.position = Vector2(0, 120)
	stats.modulate = Color(0.7, 1.0, 0.7)
	final_panel.add_child(stats)

# Event handlers
func _on_final_gem_collected(body: Node):
	"""Called quando gema final é coletada"""
	if body.is_in_group("player"):
		var gem_node = body.get_parent()
		if not gem_node.is_collected:
			# Verificar todos os requisitos finais
			var can_collect = check_all_final_requirements(gem_node.requirements)
			
			if can_collect:
				gem_node.is_collected = true
				gem_node.queue_free()
				show_feedback("GEM FINAL COLETADA! PARABÉNS!", Color.GOLD)
				
				# Trigger completion automática
				await get_tree().create_timer(2.0).timeout
				complete_level()

func check_all_final_requirements(requirements: Dictionary) -> bool:
	"""Verifica todos os requisitos finais"""
	# Verificar microservices
	if requirements.requires_microservices and microservices_deployed.size() < 3:
		return false
	
	# Verificar testes
	if requirements.requires_tests > 0 and (float(tests_passing) / float(tests_total)) < (requirements.requires_tests / 100.0):
		return false
	
	# Verificar CQRS
	if requirements.requires_cqrs and not integration_points.has("cqrs_implemented"):
		return false
	
	# Verificar cache optimization
	if requirements.requires_cache_optimization and architecture_components.size() < 10:
		return false
	
	# Verificar monitoring completo
	if requirements.requires_full_monitoring and architecture_components.size() < 15:
		return false
	
	return true

func show_feedback(message: String, color: Color):
	"""Mostra feedback temporário"""
	var feedback = Label.new()
	feedback.text = message
	feedback.modulate = color
	feedback.position = Vector2(300, 200)
	feedback.scale = Vector2(1.5, 1.5)
	add_child(feedback)
	
	# Animar e remover
	var tween = create_tween()
	tween.tween_property(feedback, "position", Vector2(300, 180), 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(feedback, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(feedback.queue_free)

# Métodos públicos
func get_level_info() -> Dictionary:
	"""Retorna informações do nível"""
	return {
		"name": level_name,
		"description": level_description,
		"current_puzzle": current_puzzle_index + 1,
		"total_puzzles": available_puzzles.size(),
		"moves_used": moves_used,
		"time_elapsed": level_timer,
		"architecture_components": architecture_components.size(),
		"tests_passing": tests_passing,
		"tests_total": tests_total,
		"microservices_deployed": microservices_deployed.size(),
		"overall_performance": performance_metrics.get("overall", 0),
		"state": LevelState.keys()[current_state]
	}

# Sinais
signal puzzle_loaded(puzzle_index: int)
signal level_completed(puzzle_count: int)
signal puzzle_completed(score: Dictionary)
signal game_completed(final_score: Dictionary)