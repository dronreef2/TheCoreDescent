# THE CORE DESCENT - NÍVEL 13: O LABORATÓRIO DE PRODUTO (PRODUCT MANAGEMENT)
# Arquivo: Level13.gd - Product Strategy, User Research, Analytics, MVP, A/B Testing
# VERSÃO OTIMIZADA: PackedStringArray, Signals, Object Pooling, Cache

extends Node2D
class_name Level13

# Configurações do nível
@export var level_name: String = "O Laboratório de Produto"
@export var level_description: String = "Gerencie todo o ciclo de vida do produto, da estratégia ao crescimento"
@export var target_moves: int = 78  # Número ideal de movimentos (70-80)
@export var grid_width: int = 44
@export var grid_height: int = 38

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
var start_position: Vector2i = Vector2i(2, 19)
var goal_position: Vector2i = Vector2i(41, 19)
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
var _strategy_pool: Array = []
var _research_pool: Array = []
var _analytics_pool: Array = []
var _feature_pool: Array = []
var _object_pool_size: int = 25

# Recursos de produto - OTIMIZADO: Inicialização eficiente
var product_infrastructure: Dictionary = {}
var user_metrics: Dictionary = {}
var market_analysis: Array = []
var competitive_intelligence: Array = []

# Puzzles disponíveis - OTIMIZADO: Cache de dados
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0
var _puzzles_cache_initialized: bool = false

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var product_dashboard: Control
var analytics_panel: Control
var user_research_view: Control

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
    print("🚀 Level13: Inicializando O Laboratório de Produto...")
    
    # Cache de conceitos para performance
    _initialize_concept_cache()
    
    # Object pools para recursos temporários
    _initialize_object_pools()
    
    # Cache de puzzles
    if not _puzzles_cache_initialized:
        _initialize_puzzles()
    
    # Conectar sinais otimizados
    _connect_optimized_signals()
    
    print("✅ Level13: Otimizações de product management aplicadas com sucesso!")

# === FUNÇÃO OTIMIZADA: CACHE DE CONCEITOS ===
func _initialize_concept_cache():
    if _concept_cache_initialized:
        return
    
    # Cache de conceitos Product Management usando PackedStringArray
    _cached_concepts = {
        "product_strategy_concepts": PackedStringArray([
            "Product Vision", "Market Opportunity", "Competitive Analysis", "Product-Market Fit",
            "Value Proposition", "Target Audience", "Product Positioning", "Business Model",
            "Go-to-Market Strategy", "Product Differentiation", "Market Segmentation", "Customer Personas",
            "Value Chain Analysis", "SWOT Analysis", "Porter's Five Forces", "Blue Ocean Strategy",
            "Market Penetration", "Product Lifecycle", "Strategic Planning", "OKRs and KPIs"
        ]),
        "user_research_concepts": PackedStringArray([
            "User Interviews", "Surveys and Questionnaires", "Usability Testing", "Focus Groups",
            "Ethnographic Research", "A/B Testing", "Heat Mapping", "Eye Tracking",
            "User Journey Mapping", "Persona Development", "Empathy Mapping", "Stakeholder Mapping",
            "Behavioral Analytics", "Data Collection", "Research Design", "Sample Size",
            "Statistical Analysis", "Qualitative Data", "Quantitative Data", "Research Validation"
        ]),
        "analytics_concepts": PackedStringArray([
            "Product Analytics", "User Behavior Tracking", "Cohort Analysis", "Funnel Analysis",
            "Retention Analysis", "Churn Analysis", "Customer Lifetime Value", "Acquisition Cost",
            "Monthly Active Users", "Daily Active Users", "Engagement Metrics", "Conversion Rate",
            "Net Promoter Score", "Customer Satisfaction", "Product Performance Metrics", "Data Visualization",
            "Dashboard Creation", "KPI Monitoring", "Predictive Analytics", "Attribution Modeling"
        ]),
        "roadmap_concepts": PackedStringArray([
            "Product Roadmap", "Feature Prioritization", "Release Planning", "Sprint Planning",
            "Backlog Management", "Epic Planning", "User Story Mapping", "Sprint Retrospective",
            "Capacity Planning", "Resource Allocation", "Dependency Management", "Timeline Estimation",
            "Risk Assessment", "Milestone Tracking", "Stakeholder Communication", "Roadmap Visualization",
            "Feature Requests", "Technical Debt", "Quality Gates", "Release Automation"
        ]),
        "mvp_concepts": PackedStringArray([
            "Minimum Viable Product", "Feature Set Definition", "Core Functionality", "User Testing",
            "Iterative Development", "Lean Startup Method", "Build-Measure-Learn", "Hypothesis Testing",
            "Validation Metrics", "Market Feedback", "Pivot Strategy", "Product Iteration",
            "User Feedback Loop", "Continuous Improvement", "Agile Development", "Customer Development",
            "Problem Validation", "Solution Validation", "Product Validation", "Business Model Validation"
        ]),
        "ab_testing_concepts": PackedStringArray([
            "A/B Testing", "Multivariate Testing", "Statistical Significance", "Sample Size Calculation",
            "Control Groups", "Test Variants", "Conversion Tracking", "Hypothesis Formulation",
            "Test Duration", "Test Completion Criteria", "Data Collection", "Results Analysis",
            "Confidence Intervals", "P-value Testing", "Test Validation", "Winner Selection",
            "Rollout Strategy", "Segment Analysis", "Sequential Testing", "Bandit Algorithms"
        ]),
        "growth_concepts": PackedStringArray([
            "Growth Hacking", "Viral Loops", "Referral Programs", "Acquisition Channels",
            "Activation Strategies", "Retention Strategies", "Engagement Optimization", "Onboarding Flow",
            "Customer Success", "Upselling", "Cross-selling", "Product-Led Growth",
            "Community Building", "Content Marketing", "Social Proof", "Network Effects",
            "Growth Metrics", "North Star Metric", "Cohort Retention", "Product-Market Expansion"
        ]),
        "stakeholder_concepts": PackedStringArray([
            "Stakeholder Management", "Executive Buy-in", "Cross-functional Teams", "Communication Strategy",
            "Requirements Gathering", "User Acceptance Testing", "Change Management", "Risk Mitigation",
            "Project Governance", "Budget Management", "Timeline Management", "Quality Assurance",
            "Legal Compliance", "Privacy Requirements", "Security Considerations", "Technical Requirements",
            "Business Requirements", "User Requirements", "Accessibility Requirements", "Performance Requirements"
        ])
    }
    
    _concept_cache_initialized = true
    print("📊 Level13: Cache de conceitos product management inicializado")

# === FUNÇÃO OTIMIZADA: OBJECT POOLING ===
func _initialize_object_pools():
    # Pool para análises estratégicas
    for i in _object_pool_size:
        _strategy_pool.append({
            "id": "strategy_analysis_" + str(i),
            "status": "available",
            "analysis_type": "competitive",
            "confidence_level": 0.85,
            "created_at": Time.get_unix_time_from_system()
        })
    
    # Pool para pesquisas de usuário
    for i in _object_pool_size:
        _research_pool.append({
            "id": "user_research_" + str(i),
            "status": "available",
            "research_type": "interview",
            "sample_size": 0,
            "completion_rate": 1.0
        })
    
    # Pool para análises de dados
    for i in _object_pool_size:
        _analytics_pool.append({
            "id": "analytics_job_" + str(i),
            "status": "available",
            "analysis_type": "cohort",
            "data_points": 1000,
            "confidence_score": 0.95
        })
    
    # Pool para desenvolvimento de features
    for i in _object_pool_size:
        _feature_pool.append({
            "id": "feature_development_" + str(i),
            "status": "available",
            "feature_type": "core",
            "priority_level": "high",
            "estimated_effort": 8
        })
    
    print("🎯 Level13: Object pools de product management inicializados (tamanho: " + str(_object_pool_size) + ")")

# === FUNÇÃO OTIMIZADA: ACQUISITION DE OBJETOS DO POOL ===
func acquire_resource_from_pool(pool_name: String) -> Dictionary:
    match pool_name:
        "strategy":
            var strategy = _strategy_pool.pop_back()
            if strategy == null:
                strategy = {"id": "strategy_analysis_new", "status": "created", "analysis_type": "basic"}
            return strategy
        "research":
            var research = _research_pool.pop_back()
            if research == null:
                research = {"id": "user_research_new", "status": "created", "research_type": "survey"}
            return research
        "analytics":
            var analytics = _analytics_pool.pop_back()
            if analytics == null:
                analytics = {"id": "analytics_job_new", "status": "created", "analysis_type": "basic"}
            return analytics
        "features":
            var features = _feature_pool.pop_back()
            if features == null:
                features = {"id": "feature_development_new", "status": "created", "feature_type": "enhancement"}
            return features
        _:
            return {"id": "unknown_resource", "status": "error"}

# === FUNÇÃO OTIMIZADA: RETURN DE OBJETOS AO POOL ===
func return_resource_to_pool(pool_name: String, resource: Dictionary):
    resource["status"] = "available"
    match pool_name:
        "strategy":
            _strategy_pool.append(resource)
        "research":
            _research_pool.append(resource)
        "analytics":
            _analytics_pool.append(resource)
        "features":
            _feature_pool.append(resource)

# === FUNÇÃO OTIMIZADA: SIGNALS OTIMIZADOS ===
func _connect_optimized_signals():
    # Conectar sinais de performance
    var performance_timer = Timer.new()
    performance_timer.wait_time = 2.5  # Atualizar a cada 2.5 segundos para Product Management
    performance_timer.connect("timeout", Callable(self, "_update_performance_metrics"))
    add_child(performance_timer)
    performance_timer.start()
    
    # Conectar sinais de eficiência de puzzles
    self.connect("puzzle_solved", Callable(self, "_on_puzzle_solved_optimized"))

func _update_performance_metrics():
    var metrics = {
        "strategy_pool_utilization": float(_object_pool_size - _strategy_pool.size()) / _object_pool_size,
        "research_pool_utilization": float(_object_pool_size - _research_pool.size()) / _object_pool_size,
        "analytics_pool_utilization": float(_object_pool_size - _analytics_pool.size()) / _object_pool_size,
        "features_pool_utilization": float(_object_pool_size - _feature_pool.size()) / _object_pool_size,
        "memory_usage_mb": OS.get_static_memory_usage() / 1024 / 1024,
        "active_puzzle_count": available_puzzles.size(),
        "product_maturity_level": "advanced"  # Product management maturity level
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
        "product_strategy":
            # Retornar análises estratégicas ao pool
            for i in range(min(4, _strategy_pool.size() + 4)):
                var strategy = {"id": "temp_strategy_" + str(i), "status": "cleanup"}
                return_resource_to_pool("strategy", strategy)
        
        "user_research":
            # Retornar pesquisas de usuário ao pool
            for i in range(min(5, _research_pool.size() + 5)):
                var research = {"id": "temp_research_" + str(i), "status": "cleanup"}
                return_resource_to_pool("research", research)

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
    
    # Atualizar métricas de performance periodicamente
    if int(level_timer) % 10 == 0 and int((level_timer - delta) * 10) % 10 != 0:
        _update_performance_metrics()

# === FUNÇÃO PRINCIPAL OTIMIZADA ===
func _initialize_puzzles():
    if _puzzles_cache_initialized:
        return
    
    available_puzzles = [
        {
            "id": "product_strategy",
            "title": "Estratégia de Produto",
            "description": "Desenvolva estratégia de produto baseada em dados de mercado e oportunidades",
            "target_moves": 70,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(18, 30),
            "blocks_required": 22,
            # OTIMIZADO: Usar cache de conceitos em vez de array dinâmico
            "concepts": get_concepts_for_puzzle("product_strategy"),
            "mechanics": {
                "market_analysis": true,
                "competitive_positioning": true,
                "value_proposition": true,
                "customer_segmentation": true,
                "business_model_design": true,
                "go_to_market": true,
                "okr_definition": true,
                "strategic_prioritization": true
            },
            "obstacles": [
                {"type": "market_research_gaps", "position": Vector2i(6, 12), "missing_data": 40},
                {"type": "competitive_disadvantage", "position": Vector2i(10, 16), "disadvantage_score": 6.2},
                {"type": "unclear_value_prop", "position": Vector2i(14, 22), "clarity_score": 3.8},
                {"type": "stakeholder_misalignment", "position": Vector2i(16, 28), "alignment_percentage": 65}
            ]
        },
        {
            "id": "user_research",
            "title": "Pesquisa e Análise de Usuário",
            "description": "Execute pesquisas de usuário e análise comportamental para insights acionáveis",
            "target_moves": 72,
            "start_position": Vector2i(4, 32),
            "goal_position": Vector2i(22, 6),
            "blocks_required": 23,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("user_research"),
            "mechanics": {
                "user_interviews": true,
                "usability_testing": true,
                "surveys_design": true,
                "data_collection": true,
                "persona_development": true,
                "journey_mapping": true,
                "behavior_analysis": true,
                "insight_validation": true
            },
            "obstacles": [
                {"type": "low_response_rate", "position": Vector2i(8, 28), "response_percentage": 12},
                {"type": "bias_in_sample", "position": Vector2i(12, 22), "bias_score": 0.7},
                {"type": "conflicting_insights", "position": Vector2i(16, 16), "conflicts": 8},
                {"type": "insufficient_sample_size", "position": Vector2i(20, 10), "required_responses": 450}
            ]
        },
        {
            "id": "analytics_insights",
            "title": "Analytics e Métricas de Produto",
            "description": "Configure dashboards e analise métricas para decisões baseadas em dados",
            "target_moves": 74,
            "start_position": Vector2i(20, 4),
            "goal_position": Vector2i(38, 32),
            "blocks_required": 24,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("analytics"),
            "mechanics": {
                "product_analytics": true,
                "cohort_analysis": true,
                "funnel_optimization": true,
                "retention_tracking": true,
                "dashboard_creation": true,
                "kpi_monitoring": true,
                "predictive_modeling": true,
                "attribution_analysis": true
            },
            "obstacles": [
                {"type": "data_quality_issues", "position": Vector2i(24, 8), "data_quality_score": 6.2},
                {"type": "attribution_complexity", "position": Vector2i(28, 16), "touchpoints": 12},
                {"type": "noise_in_metrics", "position": Vector2i(32, 24), "noise_ratio": 0.4},
                {"type": "delayed_data_feeds", "position": Vector2i(36, 30), "delay_hours": 24}
            ]
        },
        {
            "id": "product_roadmap",
            "title": "Roadmap e Planejamento",
            "description": "Crie roadmap de produto e gerencie priorização de features",
            "target_moves": 76,
            "start_position": Vector2i(8, 34),
            "goal_position": Vector2i(26, 4),
            "blocks_required": 25,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("roadmap"),
            "mechanics": {
                "roadmap_creation": true,
                "feature_prioritization": true,
                "sprint_planning": true,
                "dependency_management": true,
                "resource_allocation": true,
                "timeline_estimation": true,
                "stakeholder_alignment": true,
                "release_planning": true
            },
            "obstacles": [
                {"type": "conflicting_priorities", "position": Vector2i(12, 30), "stakeholder_count": 6},
                {"type": "technical_debt", "position": Vector2i(16, 24), "debt_hours": 320},
                {"type": "resource_constraints", "position": Vector2i(20, 18), "constraint_level": "high"},
                {"type": "changing_requirements", "position": Vector2i(24, 12), "change_requests": 15}
            ]
        },
        {
            "id": "mvp_development",
            "title": "MVP e Desenvolvimento Iterativo",
            "description": "Desenvolva MVP usando metodologias lean startup e validação contínua",
            "target_moves": 77,
            "start_position": Vector2i(30, 12),
            "goal_position": Vector2i(42, 28),
            "blocks_required": 26,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("mvp"),
            "mechanics": {
                "mvp_definition": true,
                "feature_reduction": true,
                "lean_methodology": true,
                "rapid_prototyping": true,
                "user_validation": true,
                "pivot_strategy": true,
                "iteration_planning": true,
                "validation_metrics": true
            },
            "obstacles": [
                {"type": "feature_bloat", "position": Vector2i(32, 16), "extra_features": 18},
                {"type": "validation_ambiguity", "position": Vector2i(34, 20), "unclear_metrics": 7},
                {"type": "time_pressure", "position": Vector2i(36, 24), "pressure_level": 8.5},
                {"type": "stakeholder_conflicts", "position": Vector2i(40, 26), "conflicts": 4}
            ]
        },
        {
            "id": "growth_optimization",
            "title": "A/B Testing e Otimização de Crescimento",
            "description": "Execute experimentos A/B e implemente estratégias de growth hacking",
            "target_moves": 78,
            "start_position": Vector2i(10, 6),
            "goal_position": Vector2i(38, 34),
            "blocks_required": 27,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("ab_testing"),
            "mechanics": {
                "experiment_design": true,
                "a_b_testing": true,
                "statistical_analysis": true,
                "growth_hacking": true,
                "viral_mechanics": true,
                "retention_optimization": true,
                "acquisition_channels": true,
                "product_led_growth": true
            },
            "obstacles": [
                {"type": "low_sample_size", "position": Vector2i(14, 10), "required_traffic": 10000},
                {"type": "test_interference", "position": Vector2i(18, 18), "active_tests": 12},
                {"type": "statistical_power", "position": Vector2i(22, 26), "power_score": 0.65},
                {"type": "implementation_delays", "position": Vector2i(30, 32), "delay_weeks": 3}
            ]
        }
    ]
    
    _puzzles_cache_initialized = true
    print("🎯 Level13: Puzzles de product management otimizados inicializados (cache: " + str(available_puzzles.size()) + " puzzles)")

# === FUNÇÃO OTIMIZADA: LÓGICA PRINCIPAL ===
func start_level():
    current_state = LevelState.PLAYING
    emit_signal("level_state_changed", current_state)
    is_timer_running = true
    _update_ui()
    print("🚀 Level13: Iniciando O Laboratório de Produto!")

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
            print("🏆 Level13: O Laboratório de Produto completo! Produto lançamento com sucesso!")
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
    print("🧹 Level13: Limpando object pools e cache de product management...")
    
    # Limpar caches
    _cached_concepts.clear()
    _concept_cache_initialized = false
    _puzzles_cache_initialized = false
    
    # Limpar object pools
    _strategy_pool.clear()
    _research_pool.clear()
    _analytics_pool.clear()
    _feature_pool.clear()
    
    # Parar timer de performance
    is_timer_running = false
    
    print("✅ Level13: Cleanup de product management otimizado concluído")
