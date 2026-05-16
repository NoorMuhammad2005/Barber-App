-- =============================================================================
-- NOIR BARBER — Supabase PostgreSQL Schema
-- Run this in your Supabase SQL Editor to set up the database.
-- =============================================================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- =============================================================================
-- TABLES
-- =============================================================================

-- Users (extends Supabase auth.users)
create table public.users (
  id          uuid primary key references auth.users(id) on delete cascade,
  name        text not null,
  phone       text,
  avatar_url  text,
  is_admin    boolean default false,
  created_at  timestamptz default now()
);

-- Barbers
create table public.barbers (
  id               uuid primary key default uuid_generate_v4(),
  name             text not null,
  name_ar          text,
  specialty        text,
  specialty_ar     text,
  bio              text,
  rating           numeric(3,1) default 5.0,
  review_count     integer default 0,
  experience_years integer default 1,
  image_url        text,
  is_available     boolean default true,
  created_at       timestamptz default now()
);

-- Services
create table public.services (
  id                uuid primary key default uuid_generate_v4(),
  name              text not null,
  name_ar           text,
  description       text,
  description_ar    text,
  price             numeric(8,2) not null,
  duration_minutes  integer not null,
  icon              text default '✂️',
  category          text default 'Hair',
  is_popular        boolean default false,
  is_active         boolean default true,
  created_at        timestamptz default now()
);

-- Bookings
create table public.bookings (
  id           uuid primary key default uuid_generate_v4(),
  user_id      uuid references public.users(id) on delete cascade,
  service_id   uuid references public.services(id),
  barber_id    uuid references public.barbers(id),
  date         date not null,
  time_slot    text not null,
  status       text check (status in ('pending','confirmed','completed','cancelled')) default 'pending',
  price        numeric(8,2) not null,
  notes        text,
  created_at   timestamptz default now()
);

-- Reviews
create table public.reviews (
  id          uuid primary key default uuid_generate_v4(),
  booking_id  uuid references public.bookings(id) on delete cascade,
  user_id     uuid references public.users(id) on delete cascade,
  rating      numeric(2,1) check (rating >= 1 and rating <= 5),
  comment     text,
  comment_ar  text,
  created_at  timestamptz default now()
);

-- Notifications
create table public.notifications (
  id          uuid primary key default uuid_generate_v4(),
  user_id     uuid references public.users(id) on delete cascade,
  title       text not null,
  body        text not null,
  type        text check (type in ('booking_confirmed','reminder','promotion','general')),
  is_read     boolean default false,
  created_at  timestamptz default now()
);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

alter table public.users        enable row level security;
alter table public.bookings     enable row level security;
alter table public.reviews      enable row level security;
alter table public.notifications enable row level security;

-- Users: can only read/update their own profile
create policy "users_self_rw" on public.users
  using (id = auth.uid())
  with check (id = auth.uid());

-- Bookings: users see only their own
create policy "bookings_user_rw" on public.bookings
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- Admins see all bookings (set is_admin = true in users table)
create policy "bookings_admin_all" on public.bookings
  using (
    exists (select 1 from public.users where id = auth.uid() and is_admin = true)
  );

-- Reviews: anyone can read, users write their own
create policy "reviews_read_all" on public.reviews for select using (true);
create policy "reviews_user_insert" on public.reviews for insert
  with check (user_id = auth.uid());

-- Services and barbers: public read
create policy "services_public_read" on public.services for select using (true);
create policy "barbers_public_read"  on public.barbers  for select using (true);

-- Notifications: users see their own
create policy "notifications_self" on public.notifications
  using (user_id = auth.uid());

-- =============================================================================
-- REALTIME
-- =============================================================================

-- Enable realtime for live booking updates
alter publication supabase_realtime add table public.bookings;
alter publication supabase_realtime add table public.notifications;

-- =============================================================================
-- FUNCTIONS & TRIGGERS
-- =============================================================================

-- Auto-create user profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.users (id, name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', 'Guest')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Update barber rating when review is submitted
create or replace function public.update_barber_rating()
returns trigger language plpgsql as $$
declare
  v_barber_id uuid;
  v_avg       numeric;
  v_count     integer;
begin
  -- Get the barber from the booking
  select barber_id into v_barber_id
  from public.bookings
  where id = new.booking_id;

  -- Compute new average
  select avg(r.rating), count(*)
  into v_avg, v_count
  from public.reviews r
  join public.bookings b on b.id = r.booking_id
  where b.barber_id = v_barber_id;

  -- Update barber
  update public.barbers
  set rating = round(v_avg, 1), review_count = v_count
  where id = v_barber_id;

  return new;
end;
$$;

create trigger after_review_insert
  after insert on public.reviews
  for each row execute procedure public.update_barber_rating();

-- =============================================================================
-- SEED DATA (Demo)
-- =============================================================================

insert into public.barbers (name, name_ar, specialty, specialty_ar, bio, rating, review_count, experience_years, image_url, is_available)
values
  ('James Harrison', 'جيمس هاريسون', 'Master Barber & Stylist', 'حلاق ماستر ومصفف شعر',
   'Award-winning master barber with 12+ years crafting iconic looks for clients worldwide.',
   4.9, 312, 12, 'https://i.pravatar.cc/300?img=11', true),
  ('Marcus Williams', 'ماركوس وليامز', 'Fade Specialist', 'متخصص الفيد',
   'Precision fade specialist known for clean lines and modern cuts.',
   4.8, 245, 8, 'https://i.pravatar.cc/300?img=12', true),
  ('Khalid Al-Rashid', 'خالد الراشد', 'Beard Artist', 'فنان اللحية',
   'Beard artistry master specializing in traditional and contemporary styles.',
   4.9, 189, 10, 'https://i.pravatar.cc/300?img=33', false),
  ('Daniel Stone', 'دانيال ستون', 'Color & Texture Expert', 'خبير الألوان والملمس',
   'Creative colorist and texture specialist bringing bold visions to life.',
   4.7, 134, 6, 'https://i.pravatar.cc/300?img=15', true);

insert into public.services (name, name_ar, description, description_ar, price, duration_minutes, icon, category, is_popular)
values
  ('Classic Haircut', 'قصة شعر كلاسيكية', 'Precision cut tailored to your style', 'قصة دقيقة مصممة وفق أسلوبك', 25.00, 30, '✂️', 'Hair', true),
  ('Beard Trim & Shape', 'تشذيب اللحية وتشكيلها', 'Expert beard shaping and grooming', 'تشكيل احترافي وعناية باللحية', 18.00, 20, '🪒', 'Beard', true),
  ('Hair Styling', 'تصفيف الشعر', 'Premium styling with top products', 'تصفيف فاخر بأفضل المنتجات', 35.00, 45, '💈', 'Hair', false),
  ('Luxury Facial', 'عناية فاخرة بالوجه', 'Deep cleanse and rejuvenation', 'تنظيف عميق وتجديد للبشرة', 45.00, 60, '✨', 'Facial', false),
  ('Hot Towel Shave', 'حلاقة بالمنشفة الساخنة', 'Traditional straight razor shave', 'حلاقة تقليدية بالموس المستقيم', 30.00, 40, '🔥', 'Shave', true),
  ('Color & Highlights', 'تلوين وهايلايت', 'Full color or partial highlights', 'تلوين كامل أو هايلايت جزئي', 65.00, 90, '🎨', 'Color', false);
