import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

class AssignmentCreateView extends StatefulWidget {
  const AssignmentCreateView({super.key});

  @override
  State<AssignmentCreateView> createState() => _AssignmentCreateViewState();
}

class _AssignmentCreateViewState extends State<AssignmentCreateView> {
  static const _employees = ['이승현 사원', '장윤호 사원', '남우현 사원', '김정욱 사원'];

  int _step = 0;
  TaskPriority? _priority;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _searchController = TextEditingController();
  final Set<String> _selected = {};

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _back() {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step -= 1);
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_step < 2) {
      setState(() => _step += 1);
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
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
                  label: _step < 2 ? '다음' : '업무 생성',
                  onTap: _next,
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.only(top: 8, bottom: 28),
      child: Text(text, style: ToyVillageTextStyle.heading2),
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
          minLines: 6,
          maxLines: 10,
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
        Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              for (final priority in TaskPriority.values.reversed)
                Expanded(child: _difficultySegment(priority)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const ToyVillageLabel(label: '급여 날짜'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Symbols.calendar_today_rounded,
                size: 20,
                color: ToyVillageColor.gray60,
              ),
              const SizedBox(width: 8),
              Text(
                '날짜 선택',
                style: ToyVillageTextStyle.body5.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ],
          ),
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
          color: selected ? ToyVillageColor.blueBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
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
    final keyword = _searchController.text.trim();
    final results = [
      for (final name in _employees)
        if (keyword.isEmpty || name.contains(keyword)) name,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _prompt('업무를 지시할 직원을 선택해주세요'),
        Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
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
                  onChanged: (_) => setState(() {}),
                  style: ToyVillageTextStyle.body5,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
        const SizedBox(height: 20),
        if (results.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 160),
            child: Center(
              child: Text(
                '아직 업무를 받은 직원이 없어요',
                style: TextStyle(color: ToyVillageColor.gray60),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: ToyVillageColor.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final name in results) _employeeRow(name),
              ],
            ),
          ),
      ],
    );
  }

  Widget _employeeRow(String name) {
    final added = _selected.contains(name);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: ToyVillageColor.gray20,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: ToyVillageTextStyle.body5),
          ),
          GestureDetector(
            onTap: () => setState(() {
              added ? _selected.remove(name) : _selected.add(name);
            }),
            child: added
                ? const Icon(
                    Symbols.close_rounded,
                    size: 24,
                    color: ToyVillageColor.gray60,
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
}
