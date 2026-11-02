import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_date_field.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment_request.dart';
import 'package:toy_village_app/features/task_assignment/data/model/employee.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_detail_view_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_mutation_view_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/employee_list_view_model.dart';

class AssignmentCreateView extends ConsumerStatefulWidget {
  final int? taskId;

  const AssignmentCreateView({super.key, this.taskId});

  @override
  ConsumerState<AssignmentCreateView> createState() =>
      _AssignmentCreateViewState();
}

class _AssignmentCreateViewState extends ConsumerState<AssignmentCreateView> {
  bool get _isEdit => widget.taskId != null;

  bool _prefilled = false;
  bool _submitting = false;

  int _step = 0;
  TaskPriority? _priority;
  DateTime? _dueDate;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final Set<int> _selected = {};
  List<Employee> _employees = const [];
  final _dropdownLink = LayerLink();
  final _dropdownController = OverlayPortalController();

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
    _searchFocus.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    _searchFocus.removeListener(_onSearchFocusChange);
    _searchFocus.dispose();
    super.dispose();
  }

  void _applyPrefill(TaskDetailModel detail) {
    _titleController.text = detail.title;
    _contentController.text = detail.content;
    _priority = detail.priority;
    _dueDate = detail.finishDate ?? DateTime.now();
    _selected
      ..clear()
      ..addAll(detail.assignees.map((a) => a.id));
    _prefilled = true;
  }

  void _onSearchFocusChange() {
    setState(() {
      if (_searchFocus.hasFocus) {
        _updateDropdown();
      } else if (_dropdownController.isShowing) {
        _dropdownController.hide();
      }
    });
  }

  void _back() {
    if (_step == 2 && _dropdownController.isShowing) {
      _dropdownController.hide();
    }
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step -= 1);
  }

  Employee? _employeeById(int id) {
    for (final employee in _employees) {
      if (employee.id == id) return employee;
    }
    return null;
  }

  bool _hasCandidate(String keyword) {
    return _employees.any(
      (employee) =>
          !_selected.contains(employee.id) &&
          _matchStart(employee.name, keyword) >= 0,
    );
  }

  void _updateDropdown() {
    final keyword = _searchController.text.trim();
    final shouldShow =
        _searchFocus.hasFocus && keyword.isNotEmpty && _hasCandidate(keyword);
    if (shouldShow && !_dropdownController.isShowing) {
      _dropdownController.show();
    } else if (!shouldShow && _dropdownController.isShowing) {
      _dropdownController.hide();
    }
  }

  void _toast(String message, {bool isError = true}) {
    showTopToast(Overlay.of(context), message, isError: isError);
  }

  bool _validateStep() {
    switch (_step) {
      case 0:
        if (_titleController.text.trim().isEmpty) {
          _toast('업무 제목을 입력해주세요');
          return false;
        }
        if (_contentController.text.trim().isEmpty) {
          _toast('상세 업무 내용을 입력해주세요');
          return false;
        }
      case 1:
        if (_priority == null) {
          _toast('업무 난이도를 선택해주세요');
          return false;
        }
        if (_dueDate == null) {
          _toast('마감 날짜를 선택해주세요');
          return false;
        }
      default:
        if (_selected.isEmpty) {
          _toast('업무를 지시할 직원을 선택해주세요');
          return false;
        }
    }
    return true;
  }

  Future<void> _next() async {
    FocusScope.of(context).unfocus();
    if (!_validateStep()) return;
    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }
    await _submit();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final request = AssignmentRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      assigneeIds: _selected.toList(),
      finishDate: _dueDate!,
      priority: _priority!,
    );

    final notifier = ref.read(assignmentMutationViewModelProvider.notifier);
    final error = _isEdit
        ? await notifier.edit(widget.taskId!, request)
        : await notifier.create(request);
    if (!mounted) return;

    if (error != null) {
      setState(() => _submitting = false);
      _toast(error);
      return;
    }
    _toast(_isEdit ? '업무가 수정되었어요' : '업무가 생성되었어요', isError: false);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEdit && !_prefilled) {
      final detail = ref.watch(assignmentDetailViewModelProvider(widget.taskId!));
      return Scaffold(
        body: SafeArea(
          child: CustomAsyncValue(
            value: detail,
            onRetry: () => ref.invalidate(
              assignmentDetailViewModelProvider(widget.taskId!),
            ),
            data: (data) {
              _applyPrefill(data);
              return _form();
            },
          ),
        ),
      );
    }
    return Scaffold(body: SafeArea(child: _form()));
  }

  Widget _form() {
    _employees =
        ref.watch(employeeListViewModelProvider).asData?.value ?? const [];

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 92),
                    child: switch (_step) {
                      0 => _stepContent(),
                      1 => _stepDifficulty(),
                      _ => _stepEmployees(),
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: ToyVillageButton(
              label: _step < 2
                  ? '다음'
                  : _isEdit
                  ? '수정 완료'
                  : '업무 생성',
              onTap: () {
                if (!_submitting) _next();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: _back,
            child: const Icon(
              Symbols.chevron_left_rounded,
              size: 28,
              color: ToyVillageColor.gray100,
            ),
          ),
          const Spacer(),
          Text(
            '${_step + 1} / 3',
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _prompt(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 32),
      child: Text(text, style: ToyVillageTextStyle.heading3),
    );
  }

  Widget _stepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _prompt('기본 업무 내용을 입력해주세요'),
        ToyVillageTextField(
          label: '업무 제목',
          hintText: '업무 제목 입력',
          controller: _titleController,
        ),
        const SizedBox(height: 24),
        ToyVillageTextField(
          label: '상세 업무 내용',
          hintText: '상세 업무 내용',
          controller: _contentController,
          minLines: 7,
        ),
      ],
    );
  }

  Widget _stepDifficulty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _prompt('기본 업무 내용을 입력해주세요'),
        const ToyVillageLabel(label: '업무 난이도'),
        const SizedBox(height: 12),
        Row(
          spacing: 8,
          children: [
            for (final priority in TaskPriority.values.reversed)
              Expanded(child: _difficultySegment(priority)),
          ],
        ),
        const SizedBox(height: 24),
        const ToyVillageLabel(label: '마감 날짜'),
        const SizedBox(height: 12),
        FeedDateField(
          value: _dueDate,
          onChanged: (date) => setState(() => _dueDate = date),
        ),
      ],
    );
  }

  Widget _difficultySegment(TaskPriority priority) {
    final selected = _priority == priority;
    return GestureDetector(
      onTap: () => setState(() => _priority = priority),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? ToyVillageColor.blueBackground : ToyVillageColor.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: selected ? ToyVillageColor.blue : Colors.transparent)
        ),
        child: Text(
          priority.label,
          style: ToyVillageTextStyle.body5.copyWith(
            color: selected ? ToyVillageColor.blue : ToyVillageColor.gray60,
          ),
        ),
      ),
    );
  }

  Widget _stepEmployees() {
    final selected = [
      for (final id in _selected)
        if (_employeeById(id) != null) _employeeById(id)!,
    ];

    const searchBarHeight = 52.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _prompt('업무를 지시할 직원을 선택해주세요'),
        CompositedTransformTarget(
          link: _dropdownLink,
          child: OverlayPortal(
            controller: _dropdownController,
            overlayChildBuilder: (context) => _dropdownOverlay(),
            child: _searchBar(searchBarHeight),
          ),
        ),
        if (selected.isNotEmpty) ...[
          const SizedBox(height: 32),
          Column(
            spacing: 8,
            children: [
              for (final employee in selected)
                _employeeCard(
                  _employeeRow(employee, keyword: '', added: true),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _dropdownOverlay() {
    final keyword = _searchController.text.trim();
    final candidates = [
      for (final employee in _employees)
        if (!_selected.contains(employee.id) &&
            _matchStart(employee.name, keyword) >= 0)
          employee,
    ];
    if (keyword.isEmpty || candidates.isEmpty) {
      return const SizedBox.shrink();
    }
    final width = MediaQuery.of(context).size.width - 40;
    return CompositedTransformFollower(
      link: _dropdownLink,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      showWhenUnlinked: false,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: _employeeCard(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final employee in candidates)
                    _employeeRow(employee, keyword: keyword, added: false),
                ],
              ),
            ),
            shadow: true,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchBar(double height) {
    final connected = _dropdownController.isShowing;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: connected
            ? const BorderRadius.vertical(top: Radius.circular(8))
            : BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Symbols.search_rounded,
            size: 16,
            color: ToyVillageColor.gray60,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              onChanged: (_) => setState(_updateDropdown),
              style: ToyVillageTextStyle.body5,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: '직원 이름으로 검색',
                hintStyle: ToyVillageTextStyle.body5.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeCard(
    Widget child, {
    bool shadow = false,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: ToyVillageColor.gray100.withValues(alpha: 0.08),
                  blurRadius: 8,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  Widget _highlightedName(String name, String keyword) {
    final start = _matchStart(name, keyword);
    if (start < 0) {
      return Text(name, style: ToyVillageTextStyle.body5);
    }
    final end = start + keyword.length;
    return Text.rich(
      TextSpan(
        style: ToyVillageTextStyle.body5,
        children: [
          TextSpan(text: name.substring(0, start)),
          TextSpan(
            text: name.substring(start, end),
            style: const TextStyle(color: ToyVillageColor.blue),
          ),
          TextSpan(text: name.substring(end)),
        ],
      ),
    );
  }

  Widget _employeeRow(
    Employee employee, {
    required String keyword,
    required bool added,
  }) {
    final name = employee.name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ToyVillageColor.gray20,
              shape: BoxShape.circle,
            ),
            child: Text(
              name.isEmpty ? '' : name.characters.first,
              style: ToyVillageTextStyle.button5.copyWith(
                color: ToyVillageColor.gray70,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _highlightedName(name, keyword)),
          GestureDetector(
            onTap: () {
              setState(() {
                added
                    ? _selected.remove(employee.id)
                    : _selected.add(employee.id);
              });
              _updateDropdown();
            },
            child: added
                ? const Icon(
                    Symbols.close_rounded,
                    size: 24,
                    color: ToyVillageColor.red,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: ToyVillageColor.blue,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Symbols.add_rounded,
                          size: 14,
                          color: ToyVillageColor.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '추가',
                          style: ToyVillageTextStyle.button5.copyWith(
                            color: ToyVillageColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int _matchStart(String name, String keyword) {
    if (keyword.isEmpty) return -1;
    final direct = name.indexOf(keyword);
    if (direct >= 0) return direct;
    final choseong = name.split('').map(_choseong).join();
    return choseong.indexOf(keyword);
  }

  static const _choseongList = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  String _choseong(String char) {
    final code = char.codeUnitAt(0);
    if (code < 0xAC00 || code > 0xD7A3) return char;
    return _choseongList[(code - 0xAC00) ~/ 588];
  }
}
