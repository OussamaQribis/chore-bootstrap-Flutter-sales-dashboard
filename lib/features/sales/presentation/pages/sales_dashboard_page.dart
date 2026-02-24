import 'package:flutter/material.dart';
import 'package:product_sales_dashboard/core/localization/app_i18n.dart';
import 'package:product_sales_dashboard/core/localization/app_localizations.dart';
import 'package:product_sales_dashboard/core/localization/locale_controller.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/product_sales_stat.dart';
import 'package:product_sales_dashboard/features/sales/domain/models/sales_report.dart';
import 'package:product_sales_dashboard/features/sales/domain/repositories/sales_repository.dart';
import 'package:product_sales_dashboard/features/sales/presentation/controllers/sales_controller.dart';

class SalesDashboardPage extends StatefulWidget {
  final SalesRepository repository;
  final LocaleController localeController;

  const SalesDashboardPage({
    super.key,
    required this.repository,
    required this.localeController,
  });

  @override
  State<SalesDashboardPage> createState() => _SalesDashboardPageState();
}

class _SalesDashboardPageState extends State<SalesDashboardPage> {
  late final SalesController controller;

  // ✅ متاح في كل الدوال
  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    controller = SalesController(repository: widget.repository);
    controller.addListener(_onAnyChanged);

    // ✅ لضمان إعادة الرسم فور تغيير اللغة
    widget.localeController.addListener(_onAnyChanged);

    controller.loadReport();
  }

  void _onAnyChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_onAnyChanged);
    controller.dispose();

    widget.localeController.removeListener(_onAnyChanged);
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: controller.selectedRange,
      helpText: l10n.t('pick_range_help'),
      cancelText: l10n.t('cancel'),
      confirmText: l10n.t('confirm'),
      saveText: l10n.t('save'),
    );

    if (picked == null) return;
    await controller.setDateRange(picked);
  }

  @override
  Widget build(BuildContext context) {
    final SalesReport? report = controller.report;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.t('app_title')),
          bottom: TabBar(
            tabs: [
              Tab(
                text: l10n.t('tab_products'),
                icon: const Icon(Icons.inventory_2_outlined),
              ),
              Tab(
                text: l10n.t('tab_most'),
                icon: const Icon(Icons.trending_up),
              ),
              Tab(
                text: l10n.t('tab_least'),
                icon: const Icon(Icons.trending_down),
              ),
              Tab(
                text: l10n.t('tab_compare'),
                icon: const Icon(Icons.bar_chart),
              ),
            ],
          ),
          actions: [
            // 🌐 لغة (ديناميكي حسب AppI18n.languages)
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: (code) => widget.localeController.setByCode(code),
              itemBuilder: (context) {
                return AppI18n.languages.map((lang) {
                  return PopupMenuItem<String>(
                    value: lang.code,
                    child: Text(lang.label),
                  );
                }).toList();
              },
            ),

            IconButton(
              onPressed: controller.isLoading ? null : controller.loadReport,
              icon: const Icon(Icons.refresh),
              tooltip: l10n.t('tooltip_refresh'),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildTopControls(),

            if (controller.isLoading) const LinearProgressIndicator(),

            if (controller.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${l10n.t('error_prefix')} ${controller.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            if (report == null && controller.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (report == null)
              Expanded(child: Center(child: Text(l10n.t('no_data'))))
            else
              Expanded(
                child: Column(
                  children: [
                    _buildSummary(report),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // المنتجات (مرتب حسب الأكثر مبيعًا)
                          _buildProductsList(report.sortedByMostSold),

                          // الأكثر (Top 5)
                          _buildProductsList(report.topProducts(limit: 5)),

                          // الأقل (Bottom 5)
                          _buildProductsList(report.bottomProducts(limit: 5)),

                          // مقارنة بسيطة (Top 8)
                          _buildComparisonView(report.topProducts(limit: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    final rangeText =
        '${_formatDate(controller.selectedRange.start)} → ${_formatDate(controller.selectedRange.end)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.isLoading ? null : _pickDateRange,
              icon: const Icon(Icons.date_range),
              label: Text(rangeText, overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(SalesReport report) {
    final top = report.sortedByMostSold.isNotEmpty
        ? report.sortedByMostSold.first
        : null;
    final bottom = report.sortedByLeastSold.isNotEmpty
        ? report.sortedByLeastSold.first
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: l10n.t('total_units'),
                  value: report.totalUnitsSold.toString(),
                  icon: Icons.shopping_cart_checkout,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryCard(
                  title: l10n.t('active_products'),
                  value:
                      '${report.productsWithSalesCount}/${report.productsCount}',
                  icon: Icons.inventory,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  title: l10n.t('most_sold'),
                  value: top == null
                      ? '-'
                      : '${top.product.name} (${top.totalSold})',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _summaryCard(
                  title: l10n.t('least_sold'),
                  value: bottom == null
                      ? '-'
                      : '${bottom.product.name} (${bottom.totalSold})',
                  icon: Icons.south_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<ProductSalesStat> items) {
    if (items.isEmpty) {
      return Center(child: Text(l10n.t('no_data')));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(item.product.name),
            subtitle: Text(
              '${l10n.t('price')}: \$${item.product.price.toStringAsFixed(2)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(l10n.t('sold')),
                Text(
                  '${item.totalSold}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComparisonView(List<ProductSalesStat> items) {
    if (items.isEmpty) {
      return Center(child: Text(l10n.t('no_data')));
    }

    final maxValue = items
        .map((e) => e.totalSold)
        .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final progress = maxValue == 0 ? 0.0 : item.totalSold / maxValue;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text('${l10n.t('units_sold')}: ${item.totalSold}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
