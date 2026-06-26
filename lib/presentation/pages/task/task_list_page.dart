import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/values/AppStrings.dart';
import '../../controllers/task_controller.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../widgets/task_card_widget.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskController taskController = Get.find<TaskController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      taskController.setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildSearchBarAndFilterSection(),
          _buildTaskListSection(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.sort_rounded, color: Colors.white),
          onPressed: () => _showSortBottomSheet(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: const Text(
          AppStrings.taskManagement,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
            fontSize: 24,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 40,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBarAndFilterSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 16.0),
            _buildStatusFilter(),
            const SizedBox(height: 16.0),
            _buildPriorityFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm công việc...',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2575FC)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trạng thái',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8.0),
        Obx(() {
          return Row(
            children: [
              FilterChipWidget(
                value: AppStrings.statusAll,
                selectedValue: taskController.status.value,
                onSelected: (val) => taskController.changeStatus(val),
                displayName: AppStrings.statusAllVi,
              ),
              const SizedBox(width: 8.0),
              FilterChipWidget(
                value: AppStrings.statusCompleted,
                selectedValue: taskController.status.value,
                onSelected: (val) => taskController.changeStatus(val),
                displayName: AppStrings.statusCompletedVi,
              ),
              const SizedBox(width: 8.0),
              FilterChipWidget(
                value: AppStrings.statusUncompleted,
                selectedValue: taskController.status.value,
                onSelected: (val) => taskController.changeStatus(val),
                displayName: AppStrings.statusUncompletedVi,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mức độ ưu tiên',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        Obx(() {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  value: 'All',
                  selectedValue: taskController.priorityFilter.value,
                  onSelected: (val) => taskController.setPriorityFilter(val),
                  displayName: 'Tất cả',
                  prefixColor: Colors.grey,
                ),
                const SizedBox(width: 8.0),
                FilterChipWidget(
                  value: 'High',
                  selectedValue: taskController.priorityFilter.value,
                  onSelected: (val) => taskController.setPriorityFilter(val),
                  displayName: 'Cao',
                  prefixColor: Colors.redAccent,
                ),
                const SizedBox(width: 8.0),
                FilterChipWidget(
                  value: 'Medium',
                  selectedValue: taskController.priorityFilter.value,
                  onSelected: (val) => taskController.setPriorityFilter(val),
                  displayName: 'Trung bình',
                  prefixColor: Colors.amber,
                ),
                const SizedBox(width: 8.0),
                FilterChipWidget(
                  value: 'Low',
                  selectedValue: taskController.priorityFilter.value,
                  onSelected: (val) => taskController.setPriorityFilter(val),
                  displayName: 'Thấp',
                  prefixColor: Colors.green,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTaskListSection() {
    return Obx(() {
      if (taskController.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2575FC)),
            ),
          ),
        );
      }

      if (taskController.errorMessage.value.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                taskController.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            ),
          ),
        );
      }

      final tasks = taskController.tasksStatus;

      if (tasks.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Không tìm thấy công việc nào',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thử tạo mới công việc hoặc thay đổi bộ lọc tìm kiếm của bạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final task = tasks[index];
              return TaskCardWidget(task: task);
            },
            childCount: tasks.length,
          ),
        ),
      );
    });
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.taskForm),
      label: const Text('Thêm công việc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      icon: const Icon(Icons.add, color: Colors.white),
      backgroundColor: const Color(0xFF2575FC),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Obx(() {
          final currentSortBy = taskController.sortBy.value;
          final currentSortAscending = taskController.sortAscending.value;

          final options = [
            {'label': 'Ngày tạo (Mới nhất)', 'sortBy': 'CreatedAt', 'ascending': false},
            {'label': 'Ngày tạo (Cũ nhất)', 'sortBy': 'CreatedAt', 'ascending': true},
            {'label': 'Ngày hết hạn (Gần nhất)', 'sortBy': 'DueDate', 'ascending': true},
            {'label': 'Ngày hết hạn (Xa nhất)', 'sortBy': 'DueDate', 'ascending': false},
            {'label': 'Mức độ ưu tiên (Cao -> Thấp)', 'sortBy': 'Priority', 'ascending': false},
            {'label': 'Mức độ ưu tiên (Thấp -> Cao)', 'sortBy': 'Priority', 'ascending': true},
            {'label': 'Tiêu đề (A -> Z)', 'sortBy': 'Title', 'ascending': true},
            {'label': 'Tiêu đề (Z -> A)', 'sortBy': 'Title', 'ascending': false},
          ];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sắp xếp công việc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final opt = options[index];
                      final isSelected = currentSortBy == opt['sortBy'] &&
                          currentSortAscending == opt['ascending'];

                      return ListTile(
                        title: Text(
                          opt['label'] as String,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF2575FC) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_rounded, color: Color(0xFF2575FC))
                            : null,
                        onTap: () {
                          taskController.setSortBy(
                            opt['sortBy'] as String,
                            opt['ascending'] as bool,
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
